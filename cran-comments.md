## R CMD check results

Local checks:

* `devtools::test()`: 0 failures, 0 warnings, 0 skipped, 253 passed
* `R CMD build .`: completed successfully and built `okxr_0.4.6.tar.gz`
* `LC_ALL=C R CMD check okxr_0.4.6.tar.gz --no-manual`: Status OK

GitHub Actions `R-CMD-check` on `main` for the previous release:

* Status: success

GitHub Actions manual `CRAN preflight` on `main` for the previous release:

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

This release updates the package version from 0.4.5 to 0.4.6. It adds OKX
compatibility updates for the current package scope, including the new REST
base URL, RPI migration support, chase algo order support, asset bill
`thirdPartyType` filters, and parser fields added by recent OKX API changes.

Runnable examples and tests do not require live credentials, do not call live
trading endpoints, and do not perform account side effects.

## Reverse dependencies

There are no known reverse dependencies.
