---
name: explainer
description: Create visual explainers, interactive walkthroughs, explorable explanations, and playable essays as a single HTML page. Use when the user requests such an artifact for a technical system, concept, phenomenon, or evidence-based interpretation. Not for ordinary conversational explanations, API reference, or marketing pages.
---

# Explainer

Build understanding that the reader can use: explain a mechanism, make a prediction, interpret evidence, build something, or judge where a model fails. A memorable insight can help, but it is not a substitute for foundations, practice, and connections. Do not force the subject into a tipping point, surprise ending, or one persuasive toy.

Read the relevant track: [technical.md](technical.md) for source-backed systems; [concept.md](concept.md) for concepts and phenomena. For teaching choices, examples, and their evidence, consult [learning-design.md](learning-design.md). These are design resources, not a fixed lesson script.

## Start from the learner

Infer the audience, purpose, and scope from the request. If unspecified, use an interested adult with no specialist knowledge of this subject; state the important assumptions briefly. Ask only when missing context would materially change the result. Do not run an approval round for every editorial choice.

Before building, make a compact learning plan in an HTML comment:

- **Starting point:** what the reader can already do; what is unknown about their background.
- **Destination:** a few observable capabilities, appropriate to the requested length. Prefer “trace one request and locate a failure” to “understand the architecture.”
- **Dependencies:** what each capability needs, where those foundations are taught or refreshed, and where they are used again.
- **Evidence of understanding:** a prediction, explanation, construction, comparison, or new case that would exercise each capability.
- **Scope and limits:** what the page leaves out and what its models cannot establish.

Scale this plan to the task. A short explanation can develop one useful capability; a long one needs several connected gains. The plan should shape the page, not appear as course-administration text.

### Prerequisites must exist on the page

A sorted list of concepts is insufficient. Audit the first diagram, interaction, and explanation for hidden prerequisites: vocabulary, notation, units, graph reading, domain conventions, and causal assumptions. For each required idea, either establish it, give a usable refresher before it is needed, or explicitly place it in the reader's assumed background.

Open with a concrete situation and a reason to care. Give enough of the whole to orient the reader, then develop the parts. Avoid both an unexplained system diagram and a long glossary before anything happens.

Introduce terms with an example and their role. Naming a variable does not teach its meaning. Before a reader operates a graph, explain what one mark, each axis, and a change represent. Link equations to the same objects and quantities in the example.

Give readers who know the foundations a clear way to skip the refresher. Give readers who struggle a route back to a worked example. Do not infer mastery from clicking Next or moving a slider.

## Build a progression, with room to explore

Choose teaching moves to fit the difficulty. Do not repeat the same question–figure–paragraph template for every section.

- **Model the reasoning.** Work through a small, concrete example. Show why each consequential step follows, not only the resulting state.
- **Support an attempt.** Let the reader complete a missing step, predict a change, compare cases, or fix a fault. Supply an optional hint and an explanation they can consult without passing a test.
- **Reduce support as understanding grows.** Move from a shown example to a related task, then a meaningfully different case. Experienced readers can start with the challenge; novices should not have to discover the foundations unaided.
- **Connect representations.** Carry the same example from objects or events to diagrams, tables, symbols, and general rules. Make the correspondence explicit. Return from the rule to a second example so the metaphor does not become the whole concept.
- **Revisit and combine.** Bring earlier ideas back when they help explain something new. Ask the reader to retrieve or apply them before restating them. A section can return to a concept at greater depth; dependency order is not a ban on revisiting.
- **Allow authorship.** Where it serves the subject, let the reader construct a case, choose a meaningful goal, remix an example, or test a conjecture. Provide an accessible starting configuration and room for several valid outcomes.

Use only the moves the page needs. A brief reference walkthrough need not become a course, and every section need not contain an exercise. Keep one understandable reading route with optional practice and deeper exploration. Hints, worked answers, and refreshers may use disclosure; essential claims and model limits remain easy to find. Do not lock the explanation behind quiz results.

Feedback should help the reader diagnose and revise: show a violated constraint, a counterexample, a mismatched prediction, or the step where reasoning diverges. A red cross alone teaches little. For open answers, offer a worked response and criteria for self-comparison; do not pretend a simple string match can grade understanding. Avoid scores, timers, confetti, and completion mechanics unless the requested product calls for them.

Where scope permits, end with a chance to use the ideas in a new case or apply a new question to the available evidence. Do not invent extra source material to supply a transfer task. Close with a concise account of what the ideas do and do not explain. For longer pieces, offer a small question to revisit later; do not claim a single sitting establishes durable learning.

## Choose visuals and interaction by learning function

A figure and its nearby explanation work together. Neither has to teach the whole subject in isolation. Use clear labels and point out relationships when the reader needs help seeing them. Prose can carry reasoning that a picture cannot.

Choose the simplest representation that supports the task: a diagram for structure, a trace for sequence, a table for exact comparison, a chart for a relationship, a simulation for a model's behavior. Keep comparisons at a shared scale and close together when practical.

Interaction earns its place when it helps the reader investigate, reason, practise, or control a difficult presentation. Ask:

1. What is the reader thinking about or trying to accomplish?
2. What evidence or feedback does the action expose?
3. Why does this action help more than a well-chosen static view?

There is no ranking in which dragging is inherently better than stepping, and no required number of interactive figures. A learner-paced trace, a prediction followed by a reveal, or linked highlighting between code and state can be useful even with a finite set of states. Remove controls whose only benefit is activity or decoration.

First isolate the difficult relationship; introduce more variables when the reader is ready to examine their interaction. Use meaningful defaults, visible affordances, and reset or undo for experiments. Do not give a novice an empty canvas or a dashboard of unexplained knobs. Do not restrict exploration to inputs that confirm the author's claim.

Preserve object identity, spatial anchors, labels, and units across views. Put instructions and results near the relevant control. A changing result must not make controls jump. Animated processes need pause and step controls where intermediate states matter; scroll should not race the reader past the explanation.

## Make the page specific to its subject

Choose a coherent visual language from the material and the audience: a workbench for assembly, field notes for observation, a score for rhythm, an annotated document for historical evidence. These are examples, not templates. Use the subject's real objects, traces, tensions, and unusual cases to give the piece character.

[engineering-textbook.css](engineering-textbook.css) is an optional quiet preset, not the required look. [intimate.css](intimate.css) is an optional overlay for that preset. Adjust actual text and chart contrast when using either. A topic does not automatically determine its palette.

Use hierarchy, composition, typography, purposeful color, and changes in scale to direct attention. Let major ideas have visual space. Avoid a repeated grid of generic cards, identical boxed figures, stock metaphors, and cosmetic sliders. Visual variety should express differences in the content; do not add decoration to meet a novelty quota.

Write with precise, concrete language. Define specialist terms where needed. Questions make good headings when they are real questions; declarative headings also work. Avoid filler, forced suspense, a compulsory moral, and claims that one interaction “proves” the world works this way.

## Build and ground the artifact

Default to one HTML file with inline CSS and JavaScript, no build step or framework. Prefer native HTML and inline SVG; use canvas for dense or pixel-based scenes. Add libraries only when they solve a real need, with exact version pins. A CDN-dependent page is not offline self-contained: embed dependencies or provide a usable fallback if offline use is required. Respect an existing project's delivery requirements.

Trace factual claims, measured values, and real cases to inspected sources. Distinguish measured data, derived results, estimates, and invented teaching examples. Small synthetic examples are welcome when clearly labelled; never present them as observations. Show assumptions and limits next to the result they qualify. Use sources appropriate to the claim; a simulation is evidence about its rules, not independent evidence for those rules.

Use semantic HTML, correct heading order, live text labels, and readable line lengths. All controls need labels, visible keyboard focus, and keyboard operation, including alternatives to dragging. Do not encode meaning through color alone. Keep text contrast at least 4.5:1, large text and meaningful graphical elements at least 3:1. Respect reduced motion; no autoplay audio. Provide text or tabular equivalents for essential canvas or visual-only information.

## Verify the learning path and the implementation

Inspect the rendered page at desktop and 360 px width. Use browser tools available in the environment; add automated tests where state or calculation complexity justifies them. Do not install a test project by default.

- Operate every control, including reset, boundary inputs, and alternate paths. Check calculations against known cases. For stochastic models, inspect variation and reproducibility.
- Check console errors, overflow, clipped labels, keyboard operation, contrast, reduced motion, and layout stability. Revisit sections after changing state; prose and diagrams must still agree.
- Read the opening as the stated audience. Can a reader interpret the first figure and start the first activity using only the declared prior knowledge and what the page has taught?
- Trace each target capability through preparation, example, and an opportunity to apply it. Does feedback explain how to recover from a plausible error?
- Try the transfer case without copying the worked example. Does it require the intended reasoning, or merely reproduce a visible answer?
- Inspect content as well as figures when understanding fails. Repair the missing foundation, representation, explanation, feedback, or task; do not assume one is always at fault.

When an independent review is warranted, a fresh subagent may inspect the artifact against the stated audience and attempt a new case. Give it the page and audience, not the intended conclusions. Treat this as an audit for gaps, not evidence of human learning: an expert model can silently supply missing prerequisites. Report what was actually checked and any remaining limits; do not claim learner testing without learners.
