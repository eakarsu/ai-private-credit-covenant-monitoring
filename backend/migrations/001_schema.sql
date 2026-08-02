CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_covenant_test"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_borrower" TEXT NOT NULL,
  "data_testDate" DATE NOT NULL,
  "data_leverageRatio" NUMERIC(16,2) NOT NULL,
  "data_covenantLimit" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_covenant_test_due ON "op_covenant_test"(due_date);

CREATE TABLE IF NOT EXISTS "op_borrowing_base"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_facility" TEXT NOT NULL,
  "data_eligibleReceivables" NUMERIC(16,2) NOT NULL,
  "data_eligibleInventory" NUMERIC(16,2) NOT NULL,
  "data_reserves" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_borrowing_base_due ON "op_borrowing_base"(due_date);

CREATE TABLE IF NOT EXISTS "op_reporting"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_borrower" TEXT NOT NULL,
  "data_deliverable" TEXT NOT NULL,
  "data_dueDate" DATE NOT NULL,
  "data_submissionStatus" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_reporting_due ON "op_reporting"(due_date);

CREATE TABLE IF NOT EXISTS "op_watchlist"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_borrower" TEXT NOT NULL,
  "data_riskSignal" TEXT NOT NULL,
  "data_exposure" NUMERIC(16,2) NOT NULL,
  "data_watchNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_watchlist_due ON "op_watchlist"(due_date);

CREATE TABLE IF NOT EXISTS "op_amendment"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_borrower" TEXT NOT NULL,
  "data_breach" TEXT NOT NULL,
  "data_waiverFee" NUMERIC(16,2) NOT NULL,
  "data_conditions" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_amendment_due ON "op_amendment"(due_date);

CREATE TABLE IF NOT EXISTS "op_collateral"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_facility" TEXT NOT NULL,
  "data_collateralType" TEXT NOT NULL,
  "data_collateralValue" NUMERIC(16,2) NOT NULL,
  "data_collateralNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_collateral_due ON "op_collateral"(due_date);

CREATE TABLE IF NOT EXISTS "op_valuation"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_borrower" TEXT NOT NULL,
  "data_enterpriseValue" NUMERIC(16,2) NOT NULL,
  "data_netDebt" NUMERIC(16,2) NOT NULL,
  "data_valuationRationale" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_valuation_due ON "op_valuation"(due_date);

CREATE TABLE IF NOT EXISTS "op_committee"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_borrower" TEXT NOT NULL,
  "data_meetingDate" DATE NOT NULL,
  "data_recommendation" TEXT NOT NULL,
  "data_committeeMemo" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_committee_due ON "op_committee"(due_date);

CREATE TABLE IF NOT EXISTS "op_borrower_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_borrower" TEXT NOT NULL,
  "data_sponsor" TEXT NOT NULL,
  "data_industry" TEXT NOT NULL,
  "data_riskOwner" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_borrower_master_due ON "op_borrower_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_facility_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_facility" TEXT NOT NULL,
  "data_commitment" NUMERIC(16,2) NOT NULL,
  "data_drawn" NUMERIC(16,2) NOT NULL,
  "data_maturity" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_facility_register_due ON "op_facility_register"(due_date);

CREATE TABLE IF NOT EXISTS "op_covenant_library"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_covenant" TEXT NOT NULL,
  "data_definition" TEXT NOT NULL,
  "data_threshold" NUMERIC(16,2) NOT NULL,
  "data_testingCadence" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_covenant_library_due ON "op_covenant_library"(due_date);

CREATE TABLE IF NOT EXISTS "op_collateral_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_collateral" TEXT NOT NULL,
  "data_lienPriority" TEXT NOT NULL,
  "data_appraisedValue" NUMERIC(16,2) NOT NULL,
  "data_appraisalDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_collateral_register_due ON "op_collateral_register"(due_date);
