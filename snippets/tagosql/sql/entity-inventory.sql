-- @title: Entity Inventory
-- @description: List the entities on your profile with their tags and last update
-- @tags: entities, inventory, list, metadata

-- entities() lists your entities (metadata, not their rows), which is how you find
-- the id to pass to entity('ENTITY_ID'). entities_tag('key','value') is the same
-- table restricted to entities carrying one tag.
SELECT id, name, tags, updated_at
FROM entities() AS e
ORDER BY updated_at DESC
LIMIT 100
