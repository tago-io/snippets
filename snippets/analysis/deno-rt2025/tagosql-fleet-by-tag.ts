// @title: TagoSQL - Latest Value Across a Fleet by Tag
// @description: Query the latest reading of a variable across every device matching a tag, with pagination
// @tags: tagosql, sql, fleet, tags, multiple devices, pagination

/*
 ** Analysis Example
 ** TagoSQL - Latest Value Across a Fleet by Tag
 **
 ** Uses the TagoSQL fleet function device_data_by_tag to fetch the latest reading of one
 ** variable from every active device carrying a tag, in a single query per page. Built for
 ** fleet views: each device contributes one row with its newest matching reading.
 **
 ** Fleet queries require a variable filter and a time lower bound, and return up to your
 ** plan's device cap per request. This snippet pages through larger fleets with the
 ** after_device body field: order by device, then pass the last device id of each page.
 **
 ** How to use:
 ** One-off queries require a profile token. Go to your profile settings, create a token,
 ** and add it to the analysis environment variables:
 **   profile_token = your profile token
 **   tag_key       = the tag key your devices share (for example "type")
 **   tag_value     = the tag value to match (for example "sensor")
 */

import type { TagoContext } from "npm:@tago-io/sdk";
import { Analysis, Utils } from "npm:@tago-io/sdk";

const TAGOIO_API = "https://api.tago.io";

const QUERY = `
  SELECT device, device_name, variable, value, time
  FROM device_data_by_tag($1, $2) AS f
  WHERE variable = $3 AND time > $4
  ORDER BY device
`;

async function startAnalysis(context: TagoContext): Promise<void> {
  const envVars = Utils.envToJson(context.environment);
  if (!envVars.profile_token) {
    return context.log("Add a profile_token to the analysis environment variables");
  }

  const tagKey = envVars.tag_key || "type";
  const tagValue = envVars.tag_value || "sensor";

  // Only readings from the last 24 hours; devices silent for longer are skipped.
  const since = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();

  const params = [
    { key: "$1", value: tagKey },
    { key: "$2", value: tagValue },
    { key: "$3", value: "temperature" },
    { key: "$4", value: since },
  ];

  let afterDevice: string | undefined;
  let totalRows = 0;

  // Each iteration fetches one page of devices; the loop ends on the first empty page.
  while (true) {
    const response = await fetch(`${TAGOIO_API}/sql/execute`, {
      method: "POST",
      headers: { token: envVars.profile_token, "Content-Type": "application/json" },
      body: JSON.stringify({ query: QUERY, params, after_device: afterDevice }),
    });

    const body = await response.json();
    if (!response.ok || !body.status) {
      return context.log(`Query failed (${response.status}): ${body.message}`);
    }

    const rows: Record<string, unknown>[] = body.result.rows;
    if (rows.length === 0) {
      break;
    }

    totalRows += rows.length;
    for (const row of rows) {
      context.log(
        `${row.device_name} (${row.device}): ${row.variable} = ${row.value} at ${row.time}`
      );
    }

    // The rows are ordered by device, so the last row carries the paging cursor.
    afterDevice = String(rows[rows.length - 1].device);
  }

  context.log(`Fleet query done: ${totalRows} devices reported temperature in the last 24 hours`);
}

Analysis.use(startAnalysis);
