// Pure list / export / deterministic-insight helpers. No DB or provider imports,
// so tests can import this module offline with provider keys unset.
export function displayValue(value) {
  if (value === null || value === undefined || value === '') return 'Not provided';
  if (typeof value === 'boolean') return value ? 'Yes' : 'No';
  return String(value);
}
export function readableLabel(key) {
  return String(key).replace(/([a-z])([A-Z])/g, '$1 $2').replace(/[_-]+/g, ' ').replace(/^./, (c) => c.toUpperCase());
}
export function buildSections(record) {
  return Object.entries(record || {}).map(([key, value]) => ({
    title: readableLabel(key),
    detail: Array.isArray(value) ? value.map(displayValue).join(', ') || 'Not provided' : typeof value === 'object' && value !== null ? JSON.stringify(value) : displayValue(value),
  }));
}
export function filterRecords(records, { q = '', status = '', risk = '', owner = '' } = {}) {
  const needle = String(q).trim().toLowerCase();
  return (records || []).filter((r) => {
    if (status && String(r.status ?? r.state ?? '') !== status) return false;
    if (risk && String(r.risk ?? '') !== risk) return false;
    if (owner && String(r.owner ?? '') !== owner) return false;
    if (!needle) return true;
    const hay = [r.title, r.subject, r.reference, r.owner, r.status, r.state, r.risk, JSON.stringify(r.payload || r.inputs || {})].join(' ').toLowerCase();
    return hay.includes(needle);
  });
}
const CSV_COLS = ['id', 'reference', 'title', 'status', 'owner', 'risk', 'amount', 'due_date'];
function csvCell(v) { const s = displayValue(v); return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s; }
export function recordsToCsv(records) {
  const lines = [CSV_COLS.join(',')];
  for (const r of records || []) lines.push(CSV_COLS.map((c) => csvCell(r[c])).join(','));
  return lines.join('\n') + '\n';
}
export function recordsToJson(records) { return JSON.stringify({ items: records || [], count: (records || []).length }, null, 2); }

const KINDS = {
  'covenant-breach-risk': 'Covenant breach risk',
  'reporting-timeliness': 'Reporting timeliness',
  'watchlist-prioritization': 'Watchlist prioritization',
};
export function insightKinds() { return Object.entries(KINDS).map(([id, label]) => ({ id, label })); }
export function deterministicInsights(records, kind, featureTitle = 'Operational records') {
  const list = records || [];
  const k = KINDS[kind] ? kind : 'covenant-breach-risk';
  const totalAmount = list.reduce((s, r) => s + (Number(r.amount) || 0), 0);
  const highRisk = list.filter((r) => ['High', 'Critical'].includes(String(r.risk))).length;
  const open = list.filter((r) => !['Approved', 'Closed'].includes(String(r.status ?? r.state))).length;
  const closed = list.length - open;
  let headline; let actions;
  if (k === 'reporting-timeliness') {
    headline = `${featureTitle} — reporting timeliness (deterministic)`;
    actions = ['Chase overdue borrower deliverables', 'Confirm due dates with borrowers', 'Escalate repeated late reporting'];
  } else if (k === 'watchlist-prioritization') {
    headline = `${featureTitle} — watchlist prioritization (deterministic)`;
    actions = ['Review high-risk borrowers first', 'Refresh watch notes', 'Assign accountable owners'];
  } else {
    headline = `${featureTitle} — covenant breach risk (deterministic)`;
    actions = ['Re-test covenant calculations', 'Validate borrower evidence', 'Prepare waiver or amendment review'];
  }
  return {
    aiGenerated: false,
    source: 'deterministic-fallback',
    label: 'Deterministic fallback (offline) — not AI-generated',
    kind: k, headline,
    metrics: [
      { label: 'Records reviewed', value: String(list.length) },
      { label: 'Open records', value: String(open) },
      { label: 'Closed records', value: String(closed) },
      { label: 'High-risk records', value: String(highRisk) },
      { label: 'Total amount', value: String(totalAmount) },
    ],
    sections: [
      { title: 'Scope', detail: `${list.length} record(s) from ${featureTitle} were reviewed locally.` },
      { title: 'Risk posture', detail: `${highRisk} high-risk record(s); ${open} open and ${closed} closed.` },
      { title: 'Method', detail: 'Deterministic counts over the records above. No provider call was made.' },
    ],
    actions,
  };
}
