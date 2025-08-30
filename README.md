# 🌿 Blockchain-based Rewilding Project Tracker

Welcome to a revolutionary platform for transparent and verifiable rewilding initiatives! This Web3 project uses the Stacks blockchain and Clarity smart contracts to provide immutable record-keeping for rewilding projects. It addresses the real-world problem of opacity in environmental conservation, where funders often struggle to verify project progress, success metrics (like biodiversity restoration, carbon sequestration, and habitat recovery), and fund usage. By leveraging blockchain, donors can confidently provide ongoing funding based on tamper-proof data, reducing fraud and increasing trust in global rewilding efforts.

## ✨ Features

🌍 Register and track rewilding projects with immutable timestamps  
📊 Record and verify key success metrics (e.g., species counts, soil health, carbon captured)  
💰 Manage funding pools with milestone-based disbursements  
🔍 Third-party verification through oracles for real-world data validation  
📈 Generate transparent reports and audits for stakeholders  
🗳️ Governance mechanisms for community-driven project decisions  
🚫 Prevent data tampering or duplicate entries with hash-based uniqueness  
🔄 Ongoing funding triggers based on verified milestones  

## 🛠 How It Works

This project involves 8 smart contracts written in Clarity, each handling a specific aspect of the rewilding ecosystem. Together, they create a decentralized, trustless system for project management and funding.

### Smart Contracts Overview

1. **ProjectRegistry.clar**: Handles registration of new rewilding projects, storing details like location, goals, and initial hashes for uniqueness. Prevents duplicates by checking project hashes.

2. **MetricTracker.clar**: Allows project owners to submit periodic success metrics (e.g., biodiversity scores, satellite data hashes). Metrics are timestamped immutably for historical tracking.

3. **VerificationOracle.clar**: Integrates with external oracles (e.g., via APIs or trusted verifiers) to confirm real-world metrics. Stores verification proofs on-chain.

4. **FundingPool.clar**: Manages escrow for donations and funds. Holds STX or tokens until milestones are met, then disburses automatically.

5. **MilestoneManager.clar**: Defines project milestones (e.g., "Restore 100 hectares by Q2"). Tracks achievement based on verified metrics and triggers events like fund releases.

6. **Governance.clar**: Enables token holders (e.g., donors or participants) to vote on project changes, such as adjusting goals or approving new verifiers.

7. **AuditLog.clar**: Maintains an immutable log of all actions, including registrations, metric updates, and fund movements, for full transparency.

8. **Reporting.clar**: Queries data across contracts to generate on-chain reports, such as progress summaries or funding audits, accessible to anyone.

### For Project Owners (e.g., Conservation Organizations)

- Register your project via `ProjectRegistry` with a unique hash of your proposal document, title, description, and initial metrics.
- Submit updates to `MetricTracker` with hashes of evidence (e.g., photos, sensor data).
- Request verifications through `VerificationOracle` by providing off-chain data references.
- Define milestones in `MilestoneManager` and watch funds auto-disburse from `FundingPool` upon verification.

Your project now has a permanent, verifiable record that builds trust with funders!

### For Donors and Funders

- Contribute to a project's `FundingPool` smart contract, specifying conditions tied to milestones.
- Use `Reporting` to view real-time progress, verified metrics from `MetricTracker` and `VerificationOracle`, and audit trails from `AuditLog`.
- Participate in `Governance` votes if holding project tokens, influencing decisions like fund allocation.
- Verify milestone achievements to trigger ongoing funding—everything is immutable and queryable.

Instant transparency ensures your contributions drive real impact!

### For Verifiers (e.g., Auditors or Scientists)

- Interact with `VerificationOracle` to submit proofs (e.g., signed hashes of field reports).
- Check logs in `AuditLog` for any discrepancies.
- Query `MetricTracker` and `MilestoneManager` to confirm data integrity before approvals.

This setup ensures third-party validation without central authority.

## 🚀 Getting Started

Deploy the Clarity contracts on the Stacks testnet or mainnet. Use tools like Clarinet for local development and testing. Integrate with wallets like Hiro for user interactions. Future expansions could include NFT-based carbon credits or cross-chain funding bridges.

Let's rewild the world, one verifiable block at a time! 🌱