import test from 'node:test';
import assert from 'node:assert/strict';
// Offline only: no provider keys are read by listTools.mjs.
delete process.env.OPENROUTER_API_KEY; delete process.env.OPENAI_API_KEY;
const { filterRecords, recordsToCsv, recordsToJson, deterministicInsights, displayValue, buildSections } = await import('../listTools.mjs');
const rows = [
  { id: 1, reference: 'A-1', title: 'Alpha review', status: 'Open', owner: 'Sam', risk: 'High', amount: 0, due_date: '2026-11-01', payload: { flagged: false } },
  { id: 2, reference: 'B-2', title: 'Beta closure', status: 'Closed', owner: 'Jo', risk: 'Low', amount: 250, due_date: '2026-11-02', payload: {} },
];
test('search/filter narrows the main list', () => {
  assert.equal(filterRecords(rows, { q: 'alpha' }).length, 1);
  assert.equal(filterRecords(rows, { status: 'Closed' })[0].reference, 'B-2');
  assert.equal(filterRecords(rows, { risk: 'High' }).length, 1);
  assert.equal(filterRecords(rows, {}).length, 2);
});
test('CSV/JSON export preserves 0 and false', () => {
  const csv = recordsToCsv(rows);
  assert.match(csv, /A-1/); assert.match(csv, /,0,/);
  const json = JSON.parse(recordsToJson(rows));
  assert.equal(json.count, 2); assert.equal(json.items[0].amount, 0);
});
test('deterministic fallback is labelled aiGenerated:false', () => {
  for (const kind of ['covenant-breach-risk', 'reporting-timeliness', 'watchlist-prioritization']) {
    const r = deterministicInsights(rows, kind, 'Test feature');
    assert.equal(r.aiGenerated, false); assert.equal(r.source, 'deterministic-fallback');
    assert.ok(r.sections.length >= 2); assert.ok(r.metrics.find((m) => m.label === 'Total amount'));
  }
  assert.equal(deterministicInsights([], 'covenant-breach-risk').metrics[0].value, '0');
});
test('labelled sections preserve false/0/empty', () => {
  assert.equal(displayValue(false), 'No'); assert.equal(displayValue(0), '0'); assert.equal(displayValue(''), 'Not provided');
  const s = buildSections({ flagged: false, amount: 0, note: '' });
  assert.equal(s.find((x) => x.title === 'Flagged').detail, 'No');
  assert.equal(s.find((x) => x.title === 'Amount').detail, '0');
});
