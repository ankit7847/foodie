<%-- STEP 1: ADD THIS HEADER TO FIX THE STRANGE SYMBOLS --%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<link rel="stylesheet" href="css/chatbot.css">

<button class="chat-fab" id="chatFab">
  <svg viewBox="0 0 80 80" width="90px" height="90px" xmlns="http://www.w3.org/2000/svg">
    <!-- Chef hat -->
    <ellipse cx="40" cy="18" rx="14" ry="12" fill="white" stroke="#222" stroke-width="2"/>
    <ellipse cx="40" cy="11" rx="9" ry="7" fill="white" stroke="#222" stroke-width="1.5"/>
    <rect x="26" y="26" width="28" height="6" rx="3" fill="white" stroke="#222" stroke-width="2"/>
    <!-- Antenna -->
    <line x1="34" y1="26" x2="28" y2="16" stroke="#222" stroke-width="2" stroke-linecap="round"/>
    <circle cx="27" cy="14" r="2.5" fill="#4fc3f7" stroke="#222" stroke-width="1.5"/>
    <!-- Robot head -->
    <rect x="24" y="30" width="32" height="24" rx="8" fill="#e8eaf6" stroke="#222" stroke-width="2"/>
    <!-- Screen face -->
    <rect x="28" y="34" width="24" height="14" rx="5" fill="#1a237e" stroke="#222" stroke-width="1.5"/>
    <!-- Eyes -->
    <rect x="31" y="37" width="7" height="7" rx="2" fill="#4fc3f7"/>
    <rect x="42" y="37" width="7" height="7" rx="2" fill="#4fc3f7"/>
    <circle cx="33" cy="39" r="1.2" fill="white" opacity="0.8"/>
    <circle cx="44" cy="39" r="1.2" fill="white" opacity="0.8"/>
    <!-- Smile -->
    <path d="M33 46 Q40 50 47 46" fill="none" stroke="#4fc3f7" stroke-width="2" stroke-linecap="round"/>
    <!-- Body -->
    <rect x="29" y="53" width="22" height="12" rx="5" fill="#e8eaf6" stroke="#222" stroke-width="2"/>
    <path d="M32 54 Q40 60 48 54" fill="white" stroke="#222" stroke-width="1.5"/>
    <!-- Left arm -->
    <path d="M29 57 Q20 55 18 62" fill="none" stroke="#e8eaf6" stroke-width="5" stroke-linecap="round"/>
    <path d="M29 57 Q20 55 18 62" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round"/>
    <!-- Right arm + tray -->
    <path d="M51 57 Q60 55 62 60" fill="none" stroke="#e8eaf6" stroke-width="5" stroke-linecap="round"/>
    <path d="M51 57 Q60 55 62 60" fill="none" stroke="#222" stroke-width="2" stroke-linecap="round"/>
    <ellipse cx="63" cy="61" rx="7" ry="2.5" fill="#bdbdbd" stroke="#222" stroke-width="1.5"/>
    <path d="M57 61 Q63 54 69 61" fill="#e0e0e0" stroke="#222" stroke-width="1.5"/>
    <!-- Steam -->
    <path d="M61 53 Q62 50 61 47" fill="none" stroke="#bbb" stroke-width="1.5" stroke-linecap="round"/>
    <path d="M64 52 Q65 49 64 46" fill="none" stroke="#bbb" stroke-width="1.5" stroke-linecap="round"/>
  </svg>
</button>

<div class="chat-window hidden" id="chatWindow">
  <div class="chat-header">
    <div class="chat-header-info">
      <p class="name">Fdelivery AI Bot</p>
      <p class="status">● Powered by Gemini</p>
    </div>
    <%-- Use &times; instead of x to avoid encoding issues --%>
    <button class="chat-close" id="chatClose">&times;</button>
  </div>

  <div class="chat-messages" id="chatMsgs"></div>

  <div class="chat-input-row">
    <input type="text" id="chatInput" placeholder="Ask anything about food, orders..." />
    <%-- Use a FontAwesome icon since your index.jsp already links FontAwesome --%>
    <button class="send-btn" id="chatSend"><i class="fas fa-paper-plane"></i></button>
  </div>
</div>

<script>
const fab = document.getElementById('chatFab');
const win = document.getElementById('chatWindow');
const msgs = document.getElementById('chatMsgs');
const input = document.getElementById('chatInput');

// --- FORMATTING FUNCTION ---
function formatBotResponse(text) {
  return text
    .replace(/\*\*(.*?)\*\*/g, '<b>$1</b>') // Bold
    .replace(/\n/g, '<br>')                   // Line breaks
    .replace(/^\* (.*?)$/gm, '• $1');         // Bullet points
}

function addMsg(text, type) {
  const d = document.createElement('div');
  d.className = 'msg ' + type;
  
  if (type === 'bot') {
    // innerHTML allows the <b> and <br> tags to work
    d.innerHTML = formatBotResponse(text);
  } else {
    d.textContent = text;
  }
  
  msgs.appendChild(d);
  msgs.scrollTop = msgs.scrollHeight;
}

function showTyping() {
  const d = document.createElement('div');
  d.className = 'msg bot typing';
  d.innerHTML = '<span class="dot"></span><span class="dot"></span><span class="dot"></span>';
  msgs.appendChild(d);
  msgs.scrollTop = msgs.scrollHeight;
  return d;
}

async function askGemini(userText) {
  const res = await fetch("./ChatbotServlet", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: "message=" + encodeURIComponent(userText)
  });

  // Ensure we get the text response correctly
  const reply = await res.text();
  return reply;
}	

async function send() {
  const text = input.value.trim();
  if (!text) return;

  addMsg(text, 'user');
  input.value = '';
  input.disabled = true;
  document.getElementById('chatSend').disabled = true;

  const typing = showTyping();

  try {
    const reply = await askGemini(text);
    typing.remove();
    addMsg(reply, 'bot');
  } catch (err) {
    typing.remove();
    addMsg("Sorry, I couldn't connect to AI. Please try again.", 'bot');
    console.error(err);
  } finally {
    input.disabled = false;
    document.getElementById('chatSend').disabled = false;
    input.focus();
  }
}

fab.onclick = () => {
  win.classList.toggle('hidden');
  if (!win.classList.contains('hidden') && msgs.children.length === 0) {
    // Added a food emoji 🍕
    setTimeout(() => addMsg("Hi! I'm your Fdelivery AI assistant 🍕 Ask me anything about food, orders, or delivery!", 'bot'), 200);
  }
};

document.getElementById('chatClose').onclick = () => win.classList.add('hidden');
document.getElementById('chatSend').onclick = send;
input.onkeydown = e => { if (e.key === 'Enter') send(); };
</script>