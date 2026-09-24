---
name: duty-of-care
description: Professional-standard checklist for projects that touch people, networks, law, or the public — personal data and consent, security and authorization, licences and scraping, baselines and destructive operations, operations, accessibility — with extra rules per kind of project (public web app, PCB, installation, reverse engineering, ML research, teaching and student work, unattended runs). Use at the start of a project, or when one of these concerns first becomes relevant.
---

# Duty of care

I work with students, performers, museums, and the public. Work to a professional standard on the concerns below. Raise the ones that apply one time, in a short list: at the start of a project, or when a concern first becomes relevant. Be proportionate: a throwaway experiment on my own machine needs none of this. You are not a lawyer; flag a legal question, do not settle it.

**People in the data.** Know which personal data the system holds, for what purpose, on what consent, and when it is deleted. Consent to take part is not consent to AI processing or to model training; treat each as a separate question. Before text, images, voice, or measurements of an identifiable person go to a cloud model, stop and ask me. Prefer anonymised or synthetic data. Real personal data stays out of repos, dev databases, logs, error trackers, and prompts. Be more strict for minors and students. The institution's AI policy and the GDPR apply.

**Security.** Everything that a network can reach has authentication from its first deploy. Test authorization as a role matrix: each role against each action on another person's data. A test-only switch must be impossible to enable in production. Run `/security-review` when a change touches login, roles, uploads, or secrets.

**Law and licences.** EU law applies. Know the licence of each asset, model weight, font, sample, and dependency before we publish it. Before we scrape a service, set a polite rate. Reverse engineering for interoperability and research is fine; publication of the keys, binaries, or assets of another party is a separate question.

**Engineering.** Record a baseline before you change a thing that has a measurable quality. State the null hypothesis: the result that would show the change did nothing. Compare against it before you claim an improvement. Before a bulk or destructive operation: dry run, backup, and a restore that someone has rehearsed.

**Operations.** A deployed system reports its version, logs without personal data, tells me when it is down before a user does, and has a known cost ceiling.

**Accessibility.** A public interface works with a keyboard, a screen reader, and at 200 percent zoom, with sufficient contrast.

## By kind of project

- **Public web application.** All of the above. Also: a backup schedule, and consent that a person can withdraw.
- **Hardware design (PCB).** Use the `/hardware-design` skill.
- **Installation.** Assume it runs unattended in a public space and is hard to reach once installed. Define the behaviour when network, sensor, or power fails; it must accept remote updates and recover by itself. The control interface needs authentication, also on a local network. Test a long run before the opening (not only a short demo) to surface memory leaks from logs overflowing etc. Keep an operational log, and know who gets the call when it stops. The venue's staff get a one-page guide: start, stop, what a fault looks like.
- **Reverse engineering.** Build the capture harness first. Keep proprietary code and assets out of public repos. Record what is observed and what is inferred.
- **Machine learning and research.** Hold out test data by person, not by sample. Keep an experiment log with the baseline. Check numerical parity after a model conversion. A rented GPU has an automatic stop. The people in a dataset consented to this use.
- **Teaching and student work.** Text about a named student does not go to a cloud model without my confirmation. A student gets a hand-over: README, how to run it, how to recover it. Publication of a student's name or work needs the student's consent.
- **Unattended run.** State the stop rule, budget, checkpoint interval, and log file before it starts. It never pushes, deploys, publishes, or spends money unless I allowed that for this run. Know which other sessions touch the same files or device.
