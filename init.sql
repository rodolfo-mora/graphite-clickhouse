CREATE TABLE IF NOT EXISTS default.graphite_reverse (
  Path String,
  Value Float64,
  Time UInt32,
  Date Date,
  Timestamp UInt32
) ENGINE = GraphiteMergeTree('graphite_rollup')
PARTITION BY toYYYYMM(Date)
ORDER BY (Path, Time);

CREATE TABLE IF NOT EXISTS default.graphite_index (
  Date Date,
  Level UInt32,
  Path String,
  Version UInt32
) ENGINE = ReplacingMergeTree(Version)
PARTITION BY toYYYYMM(Date)
ORDER BY (Level, Path, Date);

CREATE TABLE IF NOT EXISTS default.graphite_tagged (
  Date Date,
  Tag1 String,
  Path String,
  Tags Array(String),
  Version UInt32
) ENGINE = ReplacingMergeTree(Version)
PARTITION BY toYYYYMM(Date)
ORDER BY (Tag1, Path, Date);

CREATE TABLE distributed_graphite_reverse AS graphite_reverse
  ENGINE = Distributed(Graphite, '', graphite_reverse, rand());

CREATE TABLE distributed_graphite_index AS graphite_index
  ENGINE = Distributed(Graphite, '', graphite_index, rand());

CREATE TABLE distributed_graphite_tagged AS graphite_tagged
  ENGINE = Distributed(Graphite, '', graphite_tagged, rand());
