# Contributing Guidelines

Thank you for considering contributing to this infrastructure project! This document provides guidelines and instructions for contributing.

## Prerequisites

Before you begin contributing, ensure you have:

1. AWS CLI configured with appropriate credentials
2. Terraform 1.x installed
3. pre-commit installed (`pip install pre-commit`)
4. Docker (for running some of the security scanning tools locally)

## Development Setup

1. Clone the repository
2. Install pre-commit hooks:
   ```bash
   pre-commit install
   ```

## Making Changes

1. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following these guidelines:
   - Follow existing code style and patterns
   - Add appropriate comments and documentation
   - Update README.md if necessary
   - Add/update tests if applicable

3. Commit your changes:
   - Use conventional commit messages:
     - `feat:` for new features
     - `fix:` for bug fixes
     - `docs:` for documentation changes
     - `chore:` for maintenance tasks
     - `refactor:` for code refactoring
     - `test:` for adding or modifying tests

4. Push your changes and create a pull request

## Testing Changes

1. Run pre-commit hooks locally:
   ```bash
   pre-commit run --all-files
   ```

2. Test your changes in the staging environment first:
   ```bash
   cd environments/staging
   terraform init
   terraform plan
   ```

3. Ensure all CI checks pass in your PR

## Security

- Never commit sensitive information (credentials, API keys, etc.)
- Use AWS Secrets Manager or SSM Parameter Store for sensitive values
- Follow security best practices in infrastructure code

## Code Review

Your pull request will be reviewed for:
- Code quality and style
- Security considerations
- Infrastructure best practices
- Documentation completeness

## Release Process

1. Changes are merged to main after approval
2. Create a release tag following semantic versioning
3. Deploy to staging environment first
4. After validation, deploy to production

## Getting Help

- Create an issue for bug reports or feature requests
- Reach out to the maintainers for questions
- Review existing documentation and issues
