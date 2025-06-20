local M = {}

local quotes = {
    "Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it.\n\n- Brian Kernighan",
    "If you don't finish then you're just busy, not productive.",
    "Adapting old programs to fit new machines usually means adapting new machines to behave like old ones.\n\n- Alan Perlis",
    "Fools ignore complexity. Pragmatists suffer it. Some can avoid it. Geniuses remove it.\n\n- Alan Perlis",
    "It is easier to change the specification to fit the program than vice versa.\n\n- Alan Perlis",
    "Simplicity does not precede complexity, but follows it.\n\n- Alan Perlis",
    "Optimization hinders evolution.\n\n- Alan Perlis",
    "Recursion is the root of computation since it trades description for time.\n\n- Alan Perlis",
    "It is better to have 100 functions operate on one data structure than 10 functions on 10 data structures.\n\n- Alan Perlis",
    "There is nothing quite so useless as doing with great efficiency something that should not be done at all.\n\n- Peter Drucker",
    "If you don't fail at least 90% of the time, you're not aiming high enough.\n\n- Alan Kay",
    "I think a lot of new programmers like to use advanced data structures and advanced language features as a way of demonstrating their ability. I call it the lion-tamer syndrome. Such demonstrations are impressive, but unless they actually translate into real wins for the project, avoid them.\n\n- Glyn Williams",
    "I would rather die of passion than of boredom.\n\n- Vincent Van Gogh",
    "If a system is to serve the creative spirit, it must be entirely comprehensible to a single individual.",
    "The computing scientist's main challenge is not to get confused by the complexities of his own making.\n\n- Edsger W. Dijkstra",
    "Progress in a fixed context is almost always a form of optimization. Creative acts generally don't stay in the context that they are in.\n\n- Alan Kay",
    "The essence of XML is this: the problem it solves is not hard, and it does not solve the problem well.\n\n- Phil Wadler",
    "A good programmer is someone who always looks both ways before crossing a one-way street.\n\n- Doug Linder",
    'Patterns mean "I have run out of language."\n\n- Rich Hickey',
    "Always code as if the person who ends up maintaining your code is a violent psychopath who knows where you live.\n\n- John Woods",
    "Unix was not designed to stop its users from doing stupid things, as that would also stop them from doing clever things.",
    "Contrary to popular belief, Unix is user friendly. It just happens to be very selective about who it decides to make friends with.",
    "Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away.",
    "There are two ways of constructing a software design: One way is to make it so simple that there are obviously no deficiencies, and the other way is to make it so complicated that there are no obvious deficiencies.\n\n- C.A.R. Hoare",
    "If you don't make mistakes, you're not working on hard enough problems.\n\n- Frank Wilczek",
    "If you don't start with a spec, every piece of code you write is a patch.\n\n- Leslie Lamport",
    "Caches are bugs waiting to happen.\n\n- Rob Pike",
    "Abstraction is not about vagueness, it is about being precise at a new semantic level.\n\n- Edsger W. Dijkstra",
    "dd is horrible on purpose. It's a joke about OS/360 JCL. But today it's an internationally standardized joke. I guess that says it all.\n\n- Rob Pike",
    "All loops are infinite ones for faulty RAM modules.",
    "All idioms must be learned. Good idioms only need to be learned once.\n\n- Alan Cooper",
    "For a successful technology, reality must take precedence over public relations, for Nature cannot be fooled.\n\n- Richard Feynman",
    "If programmers were electricians, parallel programmers would be bomb disposal experts. Both cut wires.\n\n- Bartosz Milewski",
    "Computers are harder to maintain at high altitude. Thinner air means less cushion between disk heads and platters. Also more radiation.",
    "Almost every programming language is overrated by its practitioners.\n\n- Larry Wall",
    "Fancy algorithms are slow when n is small, and n is usually small.\n\n- Rob Pike",
    "Methods are just functions with a special first argument.\n\n- Andrew Gerrand",
    "Care about your craft. Why spend your life developing software unless you care about doing it well?",
    "Provide options, don't make lame excuses. Instead of excuses, provide options. Don't say it can't be done; explain what can be done.",
    "Be a catalyst for change. You can't force change on people. Instead, show them how the future might be and help them participate in creating it.",
    "Make quality a requirements issue. Involve your users in determining the project's real quality requirements.",
    "Critically analyze what you read and hear. Don't be swayed by vendors, media hype, or dogma. Analyze information in terms of you and your project.",
    "DRY - Don't Repeat Yourself. Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.",
    "Eliminate effects between unrelated things. Design components that are self-contained, independent, and have a single, well-defined purpose.",
    "Use tracer bullets to find the target. Tracer bullets let you home in on your target by trying things and seeing how close they land.",
    "Program close to the problem domain. Design and code in your user's language.",
    "Iterate the schedule with the code. Use experience you gain as you implement to refine the project time scales.",
    "Use the power of command shells. Use the shell when graphical user interfaces don't cut it.",
    "Always use source code control. Source code control is a time machine for your work - you can go back.",
    "Don't panic when debugging Take a deep breath and THINK! about what could be causing the bug.",
    "Don't assume it - prove it. Prove your assumptions in the actual environment - with real data and boundary conditions.",
    "Write code that writes code. Code generators increase your productivity and help avoid duplication.",
    "Design With contracts. Use contracts to document and verify that code does no more and no less than it claims to do.",
    "Use assertions to prevent the impossible. Assertions validate your assumptions. Use them to protect your code from an uncertain world.",
    "Finish what you start. Where possible, the routine or object that allocates a resource should be responsible for deallocating it.",
    "Configure, don't integrate. Implement technology choices for an application as configuration options, not through integration or engineering.",
    "Analyze workflow to improve concurrency. Exploit concurrency in your user's workflow.",
    "Always design for concurrency. Allow for concurrency, and you'll design cleaner interfaces with fewer assumptions.",
    "Use blackboards to coordinate workflow. Use blackboards to coordinate disparate facts and agents, while maintaining independence and isolation among participants.",
    "Estimate the order of your algorithms. Get a feel for how long things are likely to take before you write code.",
    "Refactor early, refactor often. Just as you might weed and rearrange a garden, rewrite, rework, and re-architect code when it needs it. Fix the root of the problem.",
    "Test your software, or your users will. Test ruthlessly. Don't make your users find bugs for you.",
    "Don't gather requirements - dig for them. Requirements rarely lie on the surface. They're buried deep beneath layers of assumptions, misconceptions, and politics.",
    "Abstractions live longer than details. Invest in the abstraction, not the implementation. Abstractions can survive the barrage of changes from different implementations and new technologies.",
    'Don\'t think outside the box - find the box. When faced with an impossible problem, identify the real constraints. Ask yourself: "Does it have to be done this way? Does it have to be done at all?"',
    "Some things are better done than described. Don't fall into the specification spiral - at some point you need to start coding.",
    "Costly tools don't produce better designs. Beware of vendor hype, industry dogma, and the aura of the price tag. Judge tools on their merits.",
    "Don't use manual procedures. A shell script or batch file will execute the same instructions, in the same order, time after time.",
    "Coding ain't done 'til all the Tests run. 'Nuff said.",
    "Test state coverage, not code coverage. Identify and test significant program states. Just testing lines of code isn't enough.",
    "English is just a programming language. Write documents as you would write code: honor the DRY principle, use metadata, MVC, automatic generation, and so on.",
    "Gently exceed your users' expectations. Come to understand your users' expectations, then deliver just that little bit more.",
    "Think about your work. Turn off the autopilot and take control. Constantly critique and appraise your work.",
    "Don't live with broken windows. Fix bad designs, wrong decisions, and poor code when you see them.",
    "Remember the big picture. Don't get so engrossed in the details that you forget to check what's happening around you.",
    "Invest regularly in your knowledge portfolio. Make learning a habit.",
    "It's both what you say and the way you say it. There's no point in having great ideas if you don't communicate them effectively.",
    "Make it easy to reuse. If it's easy to reuse, people will. Create an environment that supports reuse.",
    "There are no final decisions. No decision is cast in stone. Instead, consider each as being written in the sand at the beach, and plan for change.",
    "Prototype to learn. Prototyping is a learning experience. Its value lies not in the code you produce, but in the lessons you learn.",
    "Estimate to avoid surprises. Estimate before you start. You'll spot potential problems up front.",
    "Keep knowledge in plain text. Plain text won't become obsolete. It helps leverage your work and simplifies debugging and testing.",
    "Use a single editor well. The editor should be an extension of your hand; make sure your editor is configurable, extensible, and programmable.",
    "Fix the problem, not the blame. It doesn't really matter whether the bug is your fault or someone else's - it is still your problem, and it still needs to be fixed.",
    '"select" isn\'t broken. It is rare to find a bug in the OS or the compiler, or even a third-party product or library. The bug is most likely in the application.',
    "Learn a text manipulation language. You spend a large part of each day working with text. Why not have the computer do some of it for you?",
    "You can't write perfect software. Software can't be perfect. Protect your code and users from the inevitable errors.",
    "Crash early. A dead program normally does a lot less damage than a crippled one.",
    "Use exceptions for exceptional problems. Exceptions can suffer from all the readability and maintainability problems of classic spaghetti code. Reserve exceptions for exceptional things.",
    'Minimize coupling between modules. Avoid coupling by writing "shy" code and applying the Law of Demeter.',
    "Put abstractions in code, details in metadata. Program for the general case, and put the specifics outside the compiled code base.",
    "Design using services. Design in terms of services-independent, concurrent objects behind well-defined, consistent interfaces.",
    "Separate views from models. Gain flexibility at low cost by designing your application in terms of models and views.",
    "Don't program by coincidence. Rely only on reliable things. Beware of accidental complexity, and don't confuse a happy coincidence with a purposeful plan.",
    "Test your estimates. Mathematical analysis of algorithms doesn't tell you everything. Try timing your code in its target environment.",
    "Design to test. Start thinking about testing before you write a line of code.",
    "Don't use wizard code you don't understand. Wizards can generate reams of code. Make sure you understand all of it before you incorporate it into your project.",
    "Work with a user to think like a user. It's the best way to gain insight into how the system will really be used.",
    "Use a project glossary. Create and maintain a single source of all the specific terms and vocabulary for a project.",
    "Start when you're ready. You've been building experience all your life. Don't ignore niggling doubts.",
    "Don't be a slave to formal methods. Don't blindly adopt any technique without putting it into the context of your development practices and capabilities.",
    "Organize teams around functionality. Don't separate designers from coders, testers from data modelers. Build teams the way you build code.",
    "Test early. Test often. Test automatically. Tests that run with every build are much more effective than test plans that sit on a shelf.",
    "Use saboteurs to test your testing. Introduce bugs on purpose in a separate copy of the source to verify that testing will catch them.",
    "Find bugs once. Once a human tester finds a bug, it should be the last time a human tester finds that bug. Automatic tests should check for it from then on.",
    "Sign your work. Craftsmen of an earlier age were proud to sign their work. You should be, too.",
    "Think twice, code once.",
    "No matter how far down the wrong road you have gone, turn back now.",
    "Why do we never have time to do it right, but always have time to do it over?",
    "Weeks of programming can save you hours of planning.",
    "To iterate is human, to recurse divine.\n\n- L. Peter Deutsch",
    "Computers are useless. They can only give you answers.\n\n- Pablo Picasso",
    "The question of whether computers can think is like the question of whether submarines can swim.\n\n- Edsger W. Dijkstra",
    "It's ridiculous to live 100 years and only be able to remember 30 million bytes. You know, less than a compact disc. The human condition is really becoming more obsolete every minute.\n\n- Marvin Minsky",
    "The city's central computer told you? R2D2, you know better than to trust a strange computer!\n\n- C3PO",
    "Most software today is very much like an Egyptian pyramid with millions of bricks piled on top of each other, with no structural integrity, but just done by brute force and thousands of slaves.\n\n- Alan Kay",
    'I\'ve finally learned what "upward compatible" means. It means we get to keep all our old mistakes.\n\n- Dennie van Tassel',
    "There are two major products that come out of Berkeley: LSD and UNIX. We don't believe this to be a coincidence.\n\n- Jeremy S. Anderson",
    "The bulk of all patents are crap. Spending time reading them is stupid. It's up to the patent owner to do so, and to enforce them.\n\n- Linus Torvalds",
    "Controlling complexity is the essence of computer programming.\n\n- Brian Kernighan",
    "Complexity kills. It sucks the life out of developers, it makes products difficult to plan, build and test, it introduces security challenges, and it causes end-user and administrator frustration.\n\n- Ray Ozzie",
    "The function of good software is to make the complex appear to be simple.\n\n- Grady Booch",
    "There's an old story about the person who wished his computer were as easy to use as his telephone. That wish has come true, since I no longer know how to use my telephone.\n\n- Bjarne Stroustrup",
    'There are only two industries that refer to their customers as "users".\n\n- Edward Tufte',
    "Most of you are familiar with the virtues of a programmer. There are three, of course: laziness, impatience, and hubris.\n\n- Larry Wall",
    "Computer science education cannot make anybody an expert programmer any more than studying brushes and pigment can make somebody an expert painter.\n\n- Eric S. Raymond",
    "Optimism is an occupational hazard of programming; feedback is the treatment.\n\n- Kent Beck",
    "First, solve the problem. Then, write the code.\n\n- John Johnson",
    "Measuring programming progress by lines of code is like measuring aircraft building progress by weight.\n\n- Bill Gates",
    "Don't worry if it doesn't work right. If everything did, you'd be out of a job.\n\n- Mosher's Law of Software Engineering",
    "A LISP programmer knows the value of everything, but the cost of nothing.\n\n- Alan J. Perlis",
    "All problems in computer science can be solved with another level of indirection.\n\n- David Wheeler",
    "Functions delay binding; data structures induce binding. Moral: Structure data late in the programming process.\n\n- Alan J. Perlis",
    "Easy things should be easy and hard things should be possible.\n\n- Larry Wall",
    "Nothing is more permanent than a temporary solution.",
    "If you can't explain something to a six-year-old, you really don't understand it yourself.\n\n- Albert Einstein",
    "All programming is an exercise in caching.\n\n- Terje Mathisen",
    "Software is hard.\n\n- Donald Knuth",
    "They did not know it was impossible, so they did it!\n\n- Mark Twain",
    "The object-oriented model makes it easy to build up programs by accretion. What this often means, in practice, is that it provides a structured way to write spaghetti code.\n\n- Paul Graham",
    "Question: How does a large software project get to be one year late?\nAnswer: One day at a time!",
    "The first 90% of the code accounts for the first 90% of the development time. The remaining 10% of the code accounts for the other 90% of the development time.\n\n- Tom Cargill",
    "In software, we rarely have meaningful requirements. Even if we do, the only measure of success that matters is whether our solution solves the customer's shifting idea of what their problem is.\n\n- Jeff Atwood",
    "If debugging is the process of removing bugs, then programming must be the process of putting them in.\n\n- Edsger W. Dijkstra",
    "640K ought to be enough for anybody.\n\n- Bill Gates, 1981",
    "To understand recursion, one must first understand recursion.\n\n- Stephen Hawking",
    "Developing tolerance for imperfection is the key factor in turning chronic starters into consistent finishers.\n\n- Jon Acuff",
    "Every great developer you know got there by solving problems they were unqualified to solve until they actually did it.\n\n- Patrick McKenzie",
    "The average user doesn't give a damn what happens, as long as (1) it works and (2) it's fast.\n\n- Daniel J. Bernstein",
    "Walking on water and developing software from a specification are easy if both are frozen.\n\n- Edward V. Berard",
    "Be curious. Read widely. Try new things. I think a lot of what people call intelligence boils down to curiosity.\n\n- Aaron Swartz",
    "What one programmer can do in one month, two programmers can do in two months.\n\n- Frederick P. Brooks",
}

M.get_quote = function() return quotes[math.random(#quotes)] end

M.word_wrap = function(text, len)
    len = len or 80

    local line_len, i = 0, 1

    repeat
        local c = text:sub(i, i)
        line_len = c == "\n" and 0 or line_len + 1

        if line_len > len then
            repeat
                i = i - 1
                c = text:sub(i, i)
            until c == " " or c == "\n"

            text = text:sub(1, i) .. "\n" .. text:sub(i + 1)
            line_len = 0
        end

        i = i + 1
    until i > #text

    return text
end

M.boxed = function(text, len)
    len = len or 80
    text = M.word_wrap(text or M.get_quote(), len - 4)
    local lines = vim.split(text, "\n")
    local max_length = 0

    for _, line in ipairs(lines) do
        if #line > max_length then max_length = #line end
    end

    local result = "╭─" .. string.rep("─", max_length) .. "─╮\n"

    for _, line in ipairs(lines) do
        result = result .. "│ " .. line:pad_right(max_length, " ") .. " │\n"
    end

    result = result .. "╰─" .. string.rep("─", max_length) .. "─╯"

    return result
end

local cow = [[
     o
      o  ^__^
         (oo)\_______
         (__)\       )\/\
             ||----w |
             ||     ||
]]

M.cowsay = function(text)
    text = text or M.get_quote()
    return M.boxed(text) .. "\n" .. cow
end

return M
