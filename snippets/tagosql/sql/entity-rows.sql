-- @title: Rows From One Entity
-- @description: Read the newest rows stored in a single entity
-- @tags: entity, data, select, basic

-- entity('ENTITY_ID') reads the rows of one entity you own. Its columns are the
-- entity's own schema, returned with their native types, so SELECT * is the safe
-- starting point; you can only reference columns the entity actually defines.
-- Call GET /sql/tables?entity_id=<id> to discover those columns.
SELECT *
FROM entity('ENTITY_ID') AS e
ORDER BY created_at DESC
LIMIT 50
