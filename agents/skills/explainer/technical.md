# Technical track

For codebases, features, protocols, specifications, architectures, boards, and commit histories. Apply the learner and verification principles in [SKILL.md](SKILL.md).

## Ground the explanation in the artifact

Read relevant source, tests, documentation, and design decisions. Identify the version or commit when behavior depends on it. Separate what the system does from why you infer it was designed that way. Explain a trade-off when evidence supports it; do not invent design intent.

Choose a concrete task through which the reader can meet the system: one request, packet, edit, signal, or failure. Show its input, desired result, and main boundaries before internal names. Architectural layers are not automatically a teaching order.

A trace should connect input → state change → output using the actual implementation. Collect real fixture values or a reproducible small run when useful. Label simplified traces and synthetic inputs. Do not invent benchmarks, execute destructive paths, or expose credentials to make a diagram more concrete.

## Teach how to read the system

Establish the foundations the audience actually needs. For a retry explanation, an application developer may know HTTP but not idempotency. A beginner may also need requests, responses, and the difference between a missing response and an operation that did not happen. Teach these distinctions before showing a distributed trace.

Carry the same example through code, state, and output. Use stable names and visual correspondence. Code listings should be as short as the explanation permits, with the relevant state nearby. Reveal detail when it helps follow the reasoning; do not truncate the part that explains a failure to meet a line-count rule.

Useful learning moves include:

| Capability | Example and supported task | Application with less support |
|---|---|---|
| Trace execution | Step through one real input and explain state changes | Predict the output for a different input |
| Understand a protocol | Follow one exchange and its fields | Locate an invalid transition or missing response |
| Diagnose a failure | Show a successful path beside a failing trace | Identify the first divergence in an unseen trace |
| Judge a trade-off | Compare two configurations on a stated workload | Construct a workload where the preferred choice loses |
| Read a board | Trace one signal or power path with units | Explain a fault from a changed connection |

Use interaction only when it serves the capability. Linked highlighting can connect code to the state it changes. A stepper can make a short but difficult trace readable. A static byte table may be sufficient for a wire format. A distribution or performance view may benefit from filtering if the aggregate hides the relationship being taught. Pick from the reasoning task, not a list of forbidden chart controls.

## Bound the result

Locate simplifications where they matter: omitted concurrency, idealized hardware, synthetic traffic, or unsupported error paths. Provide source links near important claims and a route into the real artifact at the end. The reader should be able to orient themselves in the source, not just recall a diagram.

Verify that the trace agrees with the inspected version, controls preserve the system's rules, and any claimed measurement has its conditions attached. Include a failure or boundary case when that is necessary to understand the design.
