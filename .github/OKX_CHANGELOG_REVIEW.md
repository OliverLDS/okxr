# OKX API Changelog Review

Review the live [OKX changelog](https://www.okx.com/docs-v5/log_en/) before every
release and whenever OKX announces a breaking change.

1. Record the review date and source URL in a fixture under
   `tests/testthat/fixtures/`.
2. Classify every change as endpoint addition, request-field change,
   response-field change, deprecation, rate-limit change, or documentation-only.
3. Map affected endpoints to exported wrappers and `.api_GET_specs` or
   `.api_POST_specs` schemas.
4. Add request-body/query tests for changed request fields and parser tests for
   new response fields. Keep unsupported response fields in `extra` JSON.
5. Mark removed API fields/endpoints deprecated before removing public arguments.
6. Run `devtools::document()`, unit tests, local `R CMD check`, and CRAN
   preflight. Link the reviewed changelog dates in `NEWS.md` and
   `cran-comments.md` when submitting to CRAN.
