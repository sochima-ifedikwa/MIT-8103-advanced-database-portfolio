-- Record EXPLAIN (ANALYZE, BUFFERS) before running this file.
-- PostgreSQL already indexes primary keys and UNIQUE constraints.
CREATE INDEX IF NOT EXISTS idx_enrollments_offering ON enrollments(offering_id);
CREATE INDEX IF NOT EXISTS idx_offerings_semester ON course_offerings(semester_id);
CREATE INDEX IF NOT EXISTS idx_results_total_score ON results(total_score);
CREATE INDEX IF NOT EXISTS idx_scores_enrollment ON assessment_scores(enrollment_id);
ANALYZE;
-- Re-run identical EXPLAIN (ANALYZE, BUFFERS) queries after indexing.
