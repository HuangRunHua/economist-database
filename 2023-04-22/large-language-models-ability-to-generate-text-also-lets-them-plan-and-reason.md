---
title: Large language models’ ability to generate text also lets them plan and reason
subtitle: What will come next?
authorName: The Economist
coverImageURL: https://www.economist.com/cdn-cgi/image/width=1424,quality=80,format=auto/media-assets/image/20230422_STD003.jpg
coverImageDescription:  
hashTag: Science & technology
publishDate: Apr 19th 2023
---

Quantum physics as a Shakespearean sonnet. Trade theory explained by a pirate. A children’s story about a space-faring dinosaur. People have had fun asking modern chatbots to produce all sorts of unusual text. Some requests have been useful in the real world—think travel itineraries, school essays or computer code. Modern large language models (llms) can generate them all, though homework-shirkers should beware: the models may get some facts wrong, and are prone to flights of fancy that their creators call “hallucinations”.

Occasional hiccups aside, all this represents tremendous progress. Even a few years ago, such programs would have been science fiction. But churning out writing on demand may not prove to be llms’ most significant ability. Their text-generating prowess allows them to act as general-purpose reasoning engines. They can follow instructions, generate plans, and issue commands for other systems to carry out.

After all, language is not just words, but “a representation of the underlying complexity” of the world, observes Percy Liang, a professor at the Institute for Human-Centred Artificial Intelligence at Stanford University. That means a model of how language works also contains, in some sense, a model of how the world works. An llm trained on large amounts of text, says Nathan Benaich of Air Street Capital, an ai investment fund, “basically learns to reason on the basis of text completion”.

Systems that use llms to control other components are proliferating. For example, Hugginggpt, created at Zhejiang University and Microsoft Research, uses Chatgpt as a task planner, farming out user requests to ai models selected from Hugging Face, a library of models trained for text, image and audio tasks. TaskMatrix.ai, created by researchers at Microsoft, features a chatbot that can interact with music services, e-commerce sites, online games and other online resources.

palm-e, created by researchers at Google, uses an “embodied” llm, trained using sensor data as well as text, to control a robot. It can understand and carry out tasks such as “bring me the rice chips from the drawer” or “push the red blocks to the coffee cup.” Auto-gpt, created by Toran Bruce Richards of Significant Gravitas, a startup, uses gpt-4 to generate and develop business ideas by knitting together a range of online resources. And so on.

The prospect of connecting llms to real-world contraptions has “the safety people freaking out”, Mr Benaich says. But making such systems safer is the focus of much research. One hope is that llms will have fewer hallucinations if they are trained on datasets combining text, images and video to provide a richer sense of how the world works. Another approach augments llms with formal reasoning capabilities, or with external modules such as task lists and long-term memory.

Observers agree that building systems around llms will drive progress for the next few years. “The field is very much moving in that direction,” says Oren Etzioni of the Allen Institute for ai.

But in academia, researchers are trying to refine and improve llms themselves, as well as experimenting with entirely new approaches. Dr Liang’s team recently developed a model called Alpaca, with a view to making it easier for academic researchers to probe the capabilities and limits of llms. That is not always easy with models developed by private firms.

Dr Liang notes that today’s llms, which are based on the so-called “transformer” architecture developed by Google, have a limited “context window”—akin to short-term memory. Doubling the length of the window increases the computational load fourfold. That limits how fast they can improve. Many researchers are working on post-transformer architectures that can support far bigger context windows—an approach that has been dubbed “long learning” (as opposed to “deep learning”).

## Hello Dave, you’re looking well today
Meanwhile, other researchers are looking to extend the capabilities of “diffusion” models. These power generative-ai models, such as Stable Diffusion, that can produce high-quality images from short text prompts (such as “An Economist cover on banking in the style of Dali”). Images are continuous, whereas text consists of discrete words. But it is possible to apply diffusion to text, says Dr Liang, which might provide another way to improve llms.

Amid the excitement Yann LeCun, one of the leading lights of modern ai, has sounded a sceptical note. In a recent debate at New York University, he argued that llms in their current form are “doomed” and that efforts to control their output, or prevent them making factual errors, will fail. “It’s not a popular opinion among my colleagues, but I don’t think it’s fixable,” he said. The field, he fears, has taken the wrong turn; llms are “an off-ramp” away from the road towards more powerful ai.

Such “artificial general intelligence” (agi) is, for some researchers, a kind of holy grail. Some think agi is within reach, and can be achieved simply by building ever-bigger llms; others, like Dr LeCun, disagree. Whether or not they eventually prove a dead end, llms have gone much further than anyone might have believed a few years ago, notes Mr Benaich. However you define agi, ai researchers seem closer to it than they were a couple of years ago. 