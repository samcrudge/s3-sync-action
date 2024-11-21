
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

---

## 📜 License

This project is licensed under the [MIT License](LICENSE.md).
