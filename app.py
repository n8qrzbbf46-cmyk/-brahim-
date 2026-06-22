#!/usr/bin/env python3
"""
Simple Web Interface for Scientific Expert Bot v5
Run with: python app.py
Then open http://127.0.0.1:5000 in your browser
"""

from flask import Flask, render_template, request, jsonify
import sys
import os

# Add parent directory to path so we can import the bot
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

try:
    from scientific_expert_bot_v5_expanded import (
        professional_chat_mode,
        calculate_molar_mass,
        CoreScientificEngine
    )
    BOT_AVAILABLE = True
except Exception as e:
    print(f"Warning: Could not import bot: {e}")
    BOT_AVAILABLE = False

app = Flask(__name__)

# Global engine
if BOT_AVAILABLE:
    ENGINE = CoreScientificEngine()
else:
    ENGINE = None

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/chat', methods=['POST'])
def chat():
    if not BOT_AVAILABLE:
        return jsonify({'response': 'Bot module not available. Please run the terminal version.'})
    
    user_message = request.json.get('message', '')
    
    # Simple response for now - in real version we would integrate chat mode properly
    if 'molar mass' in user_message.lower():
        # Extract formula
        import re
        match = re.search(r'([A-Z][a-z]?\d*)+', user_message)
        if match:
            formula = match.group(0)
            mass, err = calculate_molar_mass(formula)
            if err:
                response = f"Error: {err}"
            else:
                response = f"Molar mass of {formula} = {mass:.4f} g/mol"
        else:
            response = "Please provide a valid chemical formula (e.g. H2O, C6H12O6)"
    elif 'projectile' in user_message.lower():
        response = "For projectile calculations, please use the terminal version for full interactive control."
    else:
        response = f"I received: '{user_message}'. For full natural language support, please use the terminal version of the bot."
    
    return jsonify({'response': response})

@app.route('/engine_status')
def engine_status():
    if ENGINE:
        return jsonify(ENGINE.list_available_modules())
    return jsonify({'status': 'Engine not available'})

if __name__ == '__main__':
    print("=" * 60)
    print("Scientific Expert Bot v5 - Web Interface")
    print("Open http://127.0.0.1:5000 in your browser")
    print("=" * 60)
    app.run(debug=True, host='0.0.0.0', port=5000)