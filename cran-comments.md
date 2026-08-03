## R CMD check results

Local checks:

* `devtools::document()` and `devtools::test()`: 0 failures, 0 warnings,
  0 skipped, 295 passed
* `R CMD build .`: completed successfully and built `okxr_0.5.0.tar.gz`
* `LC_ALL=C R CMD check okxr_0.5.0.tar.gz --no-manual`: Status OK

GitHub Actions manual `CRAN preflight` on `main`:

* To be run for the final `0.5.0` commit on Ubuntu latest with R devel and
  TinyTeX.
* The workflow uploads `okxr.Rcheck` regardless of check outcome so the PDF
  manual log can be inspected directly.

## Test environments

* Local macOS, R 4.2.3
* GitHub Actions configured for macOS latest, Windows latest, Ubuntu latest,
  R release
* GitHub Actions manual CRAN preflight, Ubuntu latest, R devel

## Submission notes

This release updates the package version from 0.4.8 to 0.5.0. It is a
client-contract hardening release: request failures now raise structured
`okxr_api_error` conditions rather than warning and returning `NULL`; retries
are opt-in; cursor pagination is available; and unknown named response fields
are retained in an `extra` JSON column. The NEWS and README document the
breaking error-handling change and a `tryCatch()` migration pattern.

Runnable examples and tests do not require live credentials, do not call live
trading endpoints, and do not perform account side effects.

## Reverse dependencies

There are no known reverse dependencies.
