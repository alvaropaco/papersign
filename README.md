# Papersign

Papersign is an open-source application for preparing, sending, and signing documents online.

[Website](https://papersign.io) · [App](https://papersign.io) · [Documentation](https://docs.papersign.io) · [Support](mailto:support@papersign.io)

Source code: [https://github.com/alvaropaco/papersign](https://github.com/alvaropaco/papersign)

## Local Development

### Requirements

- Node.js 24 or newer
- npm 11.17 or newer
- Docker with Docker Compose for the developer quickstart
- PostgreSQL for a manual setup

### Developer Quickstart

1. Clone the repository:

   ```sh
   git clone https://github.com/alvaropaco/papersign
   cd papersign
   ```

2. Create your environment file:

   ```sh
   cp .env.example .env
   ```

3. Install dependencies, start the local Docker services, apply database migrations, and seed the database:

   ```sh
   npm run dx
   ```

4. Start the development server:

   ```sh
   npm run dev
   ```

The application is available at `http://localhost:3000`. The local Inbucket web interface is available at `http://localhost:9000`.

For setup without the quickstart, follow the [manual development guide](https://docs.papersign.io/docs/developers/local-development/manual).

## Configuration

See `.env.example` for local defaults and the [environment variable reference](https://docs.papersign.io/docs/self-hosting/configuration/environment) for deployment configuration.

## Docker and Self-Hosting

Dockerfiles and Compose configurations are available in `docker/`. See the [Docker setup notes](./docker/README.md) and the [self-hosting documentation](https://docs.papersign.io/docs/self-hosting) for deployment instructions.

A Render blueprint is provided in `render.yaml`.

## Tech Stack

Papersign uses TypeScript, React Router, Hono, Prisma, Tailwind CSS, tRPC, and Playwright.

## Contributing

See the [contribution guide](./CONTRIBUTING.md) before submitting changes.

## Security

Report vulnerabilities privately through [GitHub Security Advisories](https://github.com/alvaropaco/papersign/security/advisories/new) or by emailing [security@papersign.io](mailto:security@papersign.io). See [SECURITY.md](./SECURITY.md) for the full policy.

## License

See [LICENSE](./LICENSE) for the license terms.
