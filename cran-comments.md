## R CMD check results

Local checks:

* `devtools::test()`: 0 failures, 0 warnings, 0 skipped, 271 passed
* `R CMD build .`: completed successfully and built `okxr_0.4.8.tar.gz`
* `LC_ALL=C R CMD check okxr_0.4.8.tar.gz --no-manual`: Status OK
* `LC_ALL=C R CMD check okxr_0.4.8.tar.gz --as-cran`: all package checks,
  documentation checks, examples, and tests passed. PDF manual generation
  could not run because the local system has no `pdflatex`; URL and clock
  NOTES are caused by the sandbox's restricted DNS/network access.

GitHub Actions `R-CMD-check` on `main`:

* Status: success
* Run: 30701670257
* Commit: cb9d419 (`release: v0.4.8`)

GitHub Actions manual `CRAN preflight` on `main`:

* Workflow status: success
* Run: 30701671507
* Commit: cb9d419 (`release: v0.4.8`)
* Runs `R CMD check --as-cran` on Ubuntu latest with R devel and TinyTeX
* Check status: 1 WARNING, 2 NOTEs

## Test environments

* Local macOS, R 4.2.3
* GitHub Actions configured for macOS latest, Windows latest, Ubuntu latest,
  R release
* GitHub Actions manual CRAN preflight, Ubuntu latest, R devel

## Known PDF manual diagnostic

The CRAN preflight retains a PDF manual warning, while the same run's manual
without index is successful. The workflow log does not retain the detailed
LaTeX output as an artifact. A previous R-devel preflight identified the
warning as `rerunfilecheck` output:

```text
File `Rd2.out' has changed. Rerun to get outlines right.
```

The same manual build log shows the second LaTeX pass resolves it:

```text
File `Rd2.out' has not changed.
```

No Rd syntax, line-width, usage, or documentation mismatch issues remain.

The R-devel GitHub Actions runner also reports two environment-related NOTEs:

```text
Skipping checking HTML validation: no command 'tidy' found.
Found the following files/directories:
  'okxr-manual.tex'
```

The `tidy` NOTE is due to the runner not installing HTML Tidy. The
`okxr-manual.tex` NOTE is a by-product of the PDF manual warning above.

## Submission notes

This release updates the package version from 0.4.7 to 0.4.8. It adds signed
GLP performance wrappers and updates the current API compatibility surface for
the July 2026 RPI migration: RPI parser fields and amendment support, X-Perp
switch timestamps, and safe deprecation handling for legacy ELP access and the
ignored `speedBump` request parameter.

Runnable examples and tests do not require live credentials, do not call live
trading endpoints, and do not perform account side effects.

## Reverse dependencies

There are no known reverse dependencies.
