---
name: test-driven-development
description: Use when changing production behavior - lean red-green-refactor, one behavior slice at a time
---

# Test-Driven Development

Drive each behavior change through red → green → refactor.

1. **Red:** Write exactly one failing test that pins the next observable
   behavior. Run it and confirm it fails for the right reason (feature
   missing, not a typo or setup error). If it passes immediately, it isn't
   testing the change — fix the test.
2. **Green:** Write the minimal production code to pass that test. Don't
   anticipate the next test, add options, or improve unrelated code.
3. **Refactor:** Only while green — remove duplication, improve names. Re-run
   the suite after each edit. Don't add behavior.
4. Repeat with the next slice.

## Rules that hold

- Vertical slices: one behavior per red-green cycle. Don't write all tests
  up front and then implement.
- Test behavior through public interfaces, not implementation details. Mock
  only at system boundaries; prefer real code.
- Bug fix = write a failing test that reproduces the bug first, then fix.
- Keep the suite green and the output clean before moving on.

## Exceptions

Throwaway prototypes, generated code, and pure configuration don't need
test-first — confirm with the user when unsure. Exploration spikes are fine;
throw the spike away and restart test-first for the real implementation.

When adding mocks or test utilities, see
[testing-anti-patterns.md](testing-anti-patterns.md).

Stop when the requested slice meets its success criteria and the relevant
validation has run (or explain why it could not).
