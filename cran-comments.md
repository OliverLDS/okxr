## R CMD check results

Local checks:

* `devtools::test()`: 0 failures, 0 warnings, 0 skipped, 243 passed
* `R CMD build .`: completed successfully and built `okxr_0.4.5.tar.gz`

GitHub Actions `R-CMD-check` on `main`:

* Status: success

GitHub Actions manual `CRAN preflight` on `main`:

* Status: success under informational warning policy
* Runs `R CMD check --as-cran` on Ubuntu latest with R devel and TinyTeX

## Test environments

* Local macOS, R 4.2.3
* GitHub Actions configured for macOS latest, Windows latest, Ubuntu latest,
  R release
* GitHub Actions manual CRAN preflight, Ubuntu latest, R devel

## Known PDF manual diagnostic

R-devel GitHub Actions shows a PDF manual warning from `rerunfilecheck`:

```text
File `Rd2.out' has changed. Rerun to get outlines right.
```

The same manual build log shows the second LaTeX pass resolves it:

```text
File `Rd2.out' has not changed.
```

No Rd syntax, line-width, usage, or documentation mismatch issues remain.

## Submission notes

This release updates the CRAN version from 0.2.4 to 0.4.5. It expands read-only
endpoint coverage, adds signed trade/account/asset action wrappers, and hardens
client-side validation for mutating request bodies.

Runnable examples and tests do not require live credentials, do not call live
trading endpoints, and do not perform account side effects.

## Reverse dependencies

There are no known reverse dependencies.
