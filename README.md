
# GitHub Action: Sync with S3 Bucket 🔄

This GitHub Action uses the [AWS CLI](https://docs.aws.amazon.com/cli/index.html) to sync a local directory (from your repository or generated during your workflow) with an S3 bucket. It is designed to be simple, secure, and highly customizable to suit various use cases.

---

## 🚀 Usage

### Example Workflow: `workflow.yml`

Place a `.yml` file like the following in your `.github/workflows` folder. For additional details, see the [workflow syntax documentation](https://help.github.com/en/articles/workflow-syntax-for-github-actions).

```yaml
name: Deploy to S3

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Sync to S3
        uses: <your-username>/<your-action>@main
        with:
          args: --acl public-read --follow-symlinks --delete
        env:
          AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
          AWS_REGION: us-west-2 # Optional: Defaults to us-east-1
          SOURCE_DIR: public    # Optional: Defaults to the root of the repository
          DEST_DIR: assets      # Optional: Defaults to the root of the S3 bucket
```

### Key Features
- **Public Website Hosting**: Use `--acl public-read` to make files publicly accessible (ensure your bucket settings allow public access).
- **Symbolic Links**: Fix potential symbolic link issues with `--follow-symlinks`.
- **Sync Optimization**: Use `--delete` to remove files in the bucket that aren't in the source directory.
- **Exclusions**: Exclude sensitive or unnecessary files like `.git` using `--exclude`.

---

## ⚙️ Configuration

Set the following environment variables in your workflow to configure the action. Sensitive data like AWS credentials should be stored as [encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

| Variable                | Description                                                                                       | Required | Default         |
|-------------------------|---------------------------------------------------------------------------------------------------|----------|-----------------|
| `AWS_S3_BUCKET`         | The name of the S3 bucket to sync with.                                                          | **Yes**  | N/A             |
| `AWS_REGION`            | The AWS region where the S3 bucket is located.                                                   | No       | `us-east-1`     |
| `SOURCE_DIR`            | The local directory to upload.                                                                   | No       | `./` (repository root) |
| `DEST_DIR`              | The target directory in the S3 bucket.                                                           | No       | `/` (bucket root) |

### Using IAM Roles for Authentication
If your GitHub Actions runner has an IAM role configured, the action will use it automatically, avoiding the need for `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

---

## 🛠 Customization

This action supports all [AWS CLI `s3 sync` flags](https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html). Add custom flags in the `args:` input of the workflow.
| **Flag**                | **Description**                                                                                   | **Use Case**                                                                                          |
|-------------------------|---------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| `--acl <value>`         | Specifies the ACL (Access Control List) for uploaded objects. Common values: `public-read`.      | Use for making files publicly readable, such as for hosting a static website.                        |
| `--delete`              | Deletes files in the destination bucket that are not present in the source directory.            | Keeps the bucket clean by removing obsolete files.                                                   |
| `--dry-run`             | Simulates the operation without making any changes.                                              | Test and verify what will happen during the sync.                                                    |
| `--exclude <pattern>`   | Excludes files that match the specified pattern. Can be repeated for multiple exclusions.         | Prevents syncing unnecessary files (e.g., `.git/*`, temporary files).                                |
| `--include <pattern>`   | Includes files that match the specified pattern (overrides exclusions).                          | Ensures specific files are included even if they match exclusion patterns.                           |
| `--follow-symlinks`     | Follows symbolic links and syncs the target files or directories.                                 | Fixes issues with symbolic links in your source directory.                                           |
| `--exact-timestamps`    | Ensures the timestamps of synced files match exactly.                                            | Useful for preserving precise timestamps between source and destination.                             |
| `--storage-class <class>`| Specifies the storage class for uploaded files. Examples: `STANDARD`, `REDUCED_REDUNDANCY`.      | Helps reduce costs by specifying lower-cost storage options if appropriate.                          |
| `--quiet`               | Suppresses most output messages.                                                                 | Use for cleaner logs during automated deployments.                                                   |
| `--no-progress`         | Disables the progress bar in the output.                                                         | Makes logs less cluttered, especially in CI environments.                                            |
| `--size-only`           | Compares files only based on size, ignoring timestamps.                                          | Speeds up syncs when file sizes are more reliable than timestamps for determining changes.            |
| `--exact-timestamps`    | Ensures the timestamps of synced files match exactly.                                            | Useful for preserving precise timestamps between source and destination.                             |
| `--endpoint-url <url>`  | Specifies a custom endpoint URL, such as for non-AWS S3-compatible services.                     | Use for services like DigitalOcean Spaces or MinIO.                                                  |
| `--region <region>`     | Specifies the AWS region for the bucket.                                                         | Ensures the sync operation targets the correct bucket region.                                         |
| `--only-show-errors`    | Shows only error messages and suppresses other output.                                           | Helps minimize output noise while still showing critical issues.                                      |
| `--source-region <region>`| Specifies the AWS region for the source bucket if syncing between two S3 buckets.               | Ensures correct source region is used in cross-region syncs.                                          |


---

## 📜 License

This project is licensed under the [MIT License](LICENSE.md).
