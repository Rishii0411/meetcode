/* MeetCode – rotating motivation quotes */
(function () {
    const quotes = [
        "Small progress is still progress.",
        "You do not need to solve everything today—just the next problem.",
        "Every bug you fix is proof that you can learn your way through difficulty.",
        "Consistency turns ordinary practice into extraordinary skill.",
        "The best time to improve your fundamentals is the problem in front of you.",
        "Your future interview confidence is built by today's focused attempt.",
        "A wrong answer is feedback wearing a disguise.",
        "Think clearly, code patiently, improve deliberately.",
        "One clean solution is better than ten rushed attempts.",
        "You are closer than your last failed submission suggests.",
        "Mastery is made of problems that once felt impossible.",
        "Do not wait to feel ready—practice is how readiness begins.",
        "Curiosity is a developer's most reliable debugging tool.",
        "The habit of showing up is already a competitive advantage.",
        "Make the next commit to your own growth.",
        "Strong developers are built one question, one insight, one day at a time.",
        "Your pace is valid; keep moving with intention.",
        "Clarity comes after the first thoughtful attempt.",
        "A difficult problem is an invitation to expand your toolkit.",
        "You are not behind—you are in the middle of becoming better.",
        "Practice the process, and results will have somewhere to grow.",
        "Every solved problem adds another pattern to your mental library.",
        "Confidence is earned quietly, through repetition.",
        "Slow down enough to understand; speed follows understanding.",
        "The solution is easier to find when you stay with the question.",
        "Progress loves a routine.",
        "Your next breakthrough may be hidden inside your next attempt.",
        "Good code starts with a calm mind and a clear problem statement.",
        "Keep learning in public, even when the audience is only your future self.",
        "Do the work that makes tomorrow easier.",
        "A focused hour can change the direction of your week.",
        "You are building more than solutions—you are building judgment.",
        "The hardest part is often starting; start anyway.",
        "Every edge case you notice makes you a sharper engineer.",
        "Let persistence be your unfair advantage.",
        "The code gets better when the questions get better.",
        "You can be both a beginner today and an expert in progress.",
        "One deliberate step beats a perfect plan that never starts.",
        "Debugging is not failure; it is the path becoming visible.",
        "Keep your standards high and your self-talk kind.",
        "Today's effort is tomorrow's intuition.",
        "The more patterns you learn, the more creative your solutions become.",
        "A challenge is temporary; the skill you gain stays with you.",
        "Build the habit first. The results will catch up.",
        "You are allowed to take the long way to a strong understanding.",
        "Every submission teaches you something the tutorial could not.",
        "Make progress visible: solve, reflect, repeat.",
        "The interview is one moment; the skill is yours forever.",
        "Keep going—your future self is taking notes."
    ];

    function showQuote() {
        const quoteElement = document.getElementById("dailyMotivationQuote");
        if (!quoteElement) return;

        const previousIndex = Number(localStorage.getItem("meetcodeQuoteIndex"));
        let nextIndex = Math.floor(Math.random() * quotes.length);

        if (quotes.length > 1 && nextIndex === previousIndex) {
            nextIndex = (nextIndex + 1) % quotes.length;
        }

        localStorage.setItem("meetcodeQuoteIndex", nextIndex);
        quoteElement.textContent = quotes[nextIndex];
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", showQuote);
    } else {
        showQuote();
    }
})();
