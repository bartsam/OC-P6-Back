# Workshop Organizer Web API

Welcome to the Workshop Organizer Web API! This application is designed to facilitate workshops open to the public. Whether you’re organizing coding bootcamps, art classes, or any other type of workshop, this API will help manage registrations, schedules, and resources.

## Table of Contents

1. Context
2. Technical Overview
3. Building and Running
4. Testing
5. Packaging
6. CI/CD

## Context

Workshops play a crucial role in fostering learning and collaboration. Our application aims to streamline the workshop organization process, making it easier for organizers to manage participants, sessions, and materials. Whether you're a seasoned workshop host or just starting out, this API has got you covered!

## Technical Overview

- **Java Development Kit (JDK):** We use **JDK 21**, tested with **Adoptium**, to power our application.
- **Database:** Our backend relies on a **PostgreSQL 13** database for data storage.
- **Build Tool:** We leverage **Gradle 8.7** for managing dependencies and building the project.
- **Spring Boot:** Our application is based on **Spring Boot 3.2.4**, which provides a robust framework for creating RESTful APIs.
- **Application Server:** Our application can run on Tomcat server that require version 10.1.24.

## Building and Running

To compile and run the application locally, follow these steps:

1. Ensure you have JDK 21 installed.
2. Clone this repository.
3. Navigate to the project root directory.
4. Execute the following command to compile the Java code :

   ```bash
   ./gradlew clean compileJava
   ```

5. To run the application locally, either:
   Execute the main method in the Application class from your IDE.
   Use the Spring Boot Gradle Plugin :

   ```bash
   ./gradlew bootRun
   ```

   For production, package the application as WAR and use a tomcat server

To run correctly the application with docker after you building it with tag workshop-organizer, run the following

```bash
docker compose up -d
```

## Configuration

You can configure the application with these environment variables

- SPRING_DATASOURCE_URL: JDBC URI for DB access (ex. jdbc:postgresql://db:5432/mydatabase)
- SPRING_DATASOURCE_USERNAME: Database user name used by the application
- SPRING_DATASOURCE_PASSWORD: Database user password used by the application

## Testing

We take testing seriously! To verify the correctness of our application, run the following command:

```bash
./gradlew clean test
```

JUnit reports are generated in the `build/test-results/test` folder.

### Test script used by CI

The repository also provides a portable test script used by GitHub Actions:

```bash
bash ./run-tests.sh
```

For this Gradle project, the script:

1. runs `./gradlew clean test`;
2. preserves the test command exit status;
3. copies JUnit XML reports from `build/test-results/test` to `test-results/`.

The `test-results/` directory is the common report location consumed by the CI workflow. It allows GitHub Actions to publish the test results in the workflow summary and retain the XML files as a build artifact, including when a test fails.

## Packaging

When you’re ready to package the application for deployment, create a deployable WAR file:

```bash
./gradlew bootWar
```

The generated war file can be used with many application servers such as Tomcat, Wildfly...

## CI/CD

The GitHub Actions workflow in `.github/workflows/ci.yml` runs for pull requests targeting `main` and for pushes to `main`.

### Pull requests to `main`

- Runs the unit tests and publishes the JUnit report.
- Builds the Docker image to validate the `Dockerfile`.
- Does not push an image or create a release.

### Pushes to `main`

- Runs the same tests.
- Builds and pushes the image to GitHub Container Registry.
- Creates a provenance attestation for the published image.
- Runs semantic-release after a successful image build.

semantic-release analyses [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) to determine whether a release is required:

- `fix: ...` creates a patch release;
- `feat: ...` creates a minor release;
- `feat!: ...` or a `BREAKING CHANGE:` footer creates a major release.

When a release is created, semantic-release updates `build.gradle`, generates `CHANGELOG.md`, creates a Git tag and GitHub Release, then adds the semantic version as an additional tag to the Docker image. Commits such as `docs:` or `ci:` alone do not create a release.

The workflow uses the automatically provided `GITHUB_TOKEN`; its permissions are scoped per job and the token is never printed in logs.

### Docker Image Tags in GitHub Container Registry

Images are published under:

```text
ghcr.io/bartsam/oc-p6-back
```

Every push to `main` produces a commit-specific image tag:

```text
ghcr.io/bartsam/oc-p6-back:main-<commit-sha>
```

When semantic-release creates a release, the same image also receives a semantic version tag, for example:

```text
ghcr.io/bartsam/oc-p6-back:<version>
```

Feel free to enhance this README with additional details, such as API endpoints, security considerations, and deployment instructions. Happy organizing! 🚀
