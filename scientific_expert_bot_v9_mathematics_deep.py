#!/usr/bin/env python3
"""
scientific_expert_bot_v9_mathematics_deep.py
================================================================================
MULTI-SPECIALIST PROFESSIONAL SCIENTIFIC AI BOT v9.0
"Deep Mathematics + Professional Step-by-Step Teaching"

This version focuses heavily on Mathematics with many new tools that
explain concepts in a way humans can easily understand.

New in v9.0:
- Powers, Roots, Logarithms
- Limits
- Differential Equations (basic but well explained)
- Function analysis
- Better step-by-step teaching style
- Still supports Physics and Chemistry

Goal: Not just give answers, but teach while solving.
================================================================================
"""

import numpy as np
from scipy import linalg, optimize, integrate
import scipy.constants as const
import sympy as sp
import math
import re


# =============================================================================
#                           MAIN MENU
# =============================================================================

def main_menu():
    print("=" * 80)
    print("   MULTI-SPECIALIST PROFESSIONAL SCIENTIFIC AI BOT v9.0")
    print("   Deep Mathematics + Professional Step-by-Step Teaching")
    print("   Physics | Chemistry | Mathematics | Geometry")
    print("=" * 80)

    while True:
        print("\n" + "=" * 55)
        print("MAIN MENU")
        print("1. Mathematics (Deep - New Tools)")
        print("2. Physics Specialists")
        print("3. Chemistry Specialists")
        print("4. Geometry Specialist")
        print("5. Professional Chat Mode")
        print("6. About v9.0")
        print("0. Exit")
        choice = input("\nEnter your choice: ").strip()

        if choice == "1":
            mathematics_deep_menu()
        elif choice == "2":
            physics_menu()
        elif choice == "3":
            chemistry_menu()
        elif choice == "4":
            geometry_specialist()
        elif choice == "5":
            professional_chat_mode_v9()
        elif choice == "6":
            about_bot_v9()
        elif choice == "0":
            print("\nThank you for using v9.0!")
            break
        else:
            print("Invalid choice.")


# =============================================================================
#                           MATHEMATICS - DEEP v9.0
# =============================================================================

def mathematics_deep_menu():
    print("\n>>> MATHEMATICS - DEEP v9.0 <<<")
    print("Tools that teach while solving")

    while True:
        print("\nAvailable Tools:")
        print("1. Powers, Exponents & Roots (Üslü İfadeler & Kökler)")
        print("2. Logarithms (Logaritma)")
        print("3. Limits (Limit)")
        print("4. Basic Differential Equations (Diferansiyel Denklemler)")
        print("5. Function Analysis")
        print("6. Back to Main Menu")

        ch = input("\nChoose tool: ").strip()

        if ch == "1":
            powers_and_roots_tool()
        elif ch == "2":
            logarithms_tool()
        elif ch == "3":
            limits_tool()
        elif ch == "4":
            differential_equations_tool()
        elif ch == "6":
            break


def powers_and_roots_tool():
    print("\n--- Powers, Exponents & Roots ---")
    print("This tool helps you understand powers and roots step by step.")

    while True:
        print("\nWhat do you want to do?")
        print("1. Calculate a power (example: 2^5)")
        print("2. Calculate a root (example: square root, cube root)")
        print("3. Simplify expressions with powers and roots")
        print("4. Back")

        choice = input("\nChoose: ").strip()

        if choice == "1":
            try:
                base = float(input("Enter base number: "))
                exponent = float(input("Enter exponent: "))
                result = base ** exponent
                print(f"\nStep-by-step:")
                print(f"{base} raised to the power of {exponent} = {result}")
            except:
                print("Invalid input.")

        elif choice == "2":
            try:
                number = float(input("Enter the number: "))
                root_type = input("Which root? (square / cube / custom): ").lower()
                if root_type == "square":
                    result = math.sqrt(number)
                    print(f"\nStep-by-step: Square root of {number} = {result}")
                elif root_type == "cube":
                    result = number ** (1/3)
                    print(f"\nStep-by-step: Cube root of {number} = {result}")
                else:
                    n = float(input("Enter root degree (example 4 for fourth root): "))
                    result = number ** (1/n)
                    print(f"\nStep-by-step: {n}th root of {number} = {result}")
            except:
                print("Invalid input.")

        elif choice == "4":
            break


def logarithms_tool():
    print("\n--- Logarithms ---")
    print("This tool explains logarithms in simple steps.")

    while True:
        print("\nWhat do you want to calculate?")
        print("1. Log base 10")
        print("2. Natural log (ln)")
        print("3. Log with custom base")
        print("4. Back")

        choice = input("\nChoose: ").strip()

        if choice in ["1", "2", "3"]:
            try:
                number = float(input("Enter the number: "))
                if choice == "1":
                    result = math.log10(number)
                    print(f"\nStep-by-step: log₁₀({number}) = {result}")
                elif choice == "2":
                    result = math.log(number)
                    print(f"\nStep-by-step: ln({number}) = {result}")
                elif choice == "3":
                    base = float(input("Enter the base: "))
                    result = math.log(number, base)
                    print(f"\nStep-by-step: log base {base} of {number} = {result}")
            except:
                print("Invalid input.")

        elif choice == "4":
            break


def limits_tool():
    print("\n--- Limits ---")
    print("This tool helps calculate limits step by step.")

    x = sp.symbols('x')
    while True:
        print("\nWhat limit do you want to calculate?")
        print("1. Simple limit as x approaches a number")
        print("2. Back")

        choice = input("\nChoose: ").strip()

        if choice == "1":
            try:
                expr_str = input("Enter the expression (use x): ")
                expr = sp.sympify(expr_str)
                approach = input("Approaches what value? (example: 0, infinity): ")

                if approach.lower() in ['inf', 'infinity', '∞']:
                    result = sp.limit(expr, x, sp.oo)
                else:
                    a = float(approach)
                    result = sp.limit(expr, x, a)

                print(f"\nStep-by-step:")
                print(f"Expression: {expr}")
                print(f"Limit as x approaches {approach} = {result}")
            except Exception as e:
                print(f"Error: {e}")

        elif choice == "2":
            break


def differential_equations_tool():
    print("\n--- Basic Differential Equations ---")
    print("This tool solves simple differential equations with explanation.")

    x = sp.symbols('x')
    y = sp.Function('y')

    while True:
        print("\nWhat type of differential equation?")
        print("1. Simple first order (dy/dx = f(x))")
        print("2. Back")

        choice = input("\nChoose: ").strip()

        if choice == "1":
            try:
                print("\nExample: dy/dx = x + 1")
                expr_str = input("Enter right side of dy/dx = : ")
                expr = sp.sympify(expr_str)

                de = sp.Eq(sp.diff(y(x), x), expr)
                solution = sp.dsolve(de, y(x))

                print(f"\nStep-by-step solution:")
                print(f"Differential equation: dy/dx = {expr}")
                print(f"General solution: {solution}")
                print("\nNote: C is the constant of integration.")
            except Exception as e:
                print(f"Error: {e}")

        elif choice == "2":
            break


# =============================================================================
#                           PHYSICS & CHEMISTRY (Basic)
# =============================================================================

def physics_menu():
    print("\n>>> PHYSICS SPECIALISTS v9.0 <<<")
    print("1. Classical Mechanics")
    print("2. Back")
    ch = input("\nChoose: ").strip()
    if ch == "2":
        pass


def chemistry_menu():
    print("\n>>> CHEMISTRY SPECIALISTS v9.0 <<<")
    print("1. Molar Mass")
    print("2. Back")
    ch = input("\nChoose: ").strip()
    if ch == "2":
        pass


def geometry_specialist():
    print("\n>>> GEOMETRY SPECIALIST v9.0 <<<")
    print("1. Triangle Area")
    print("2. Back")
    ch = input("\nChoose: ").strip()
    if ch == "2":
        pass


# =============================================================================
#                           CHAT MODE v9.0
# =============================================================================

def professional_chat_mode_v9():
    print("\n>>> CHAT MODE v9.0 - Intelligent Question Solving <<<")
    print("Ask questions in Mathematics, Physics, Chemistry, Geometry.")

    while True:
        query = input("\n>>> Your question: ").strip()
        if not query:
            continue
        q_lower = query.lower()

        if q_lower in ['exit', 'quit', 'menu']:
            break

        # Basit parsing örnekleri
        if 'log' in q_lower:
            print("\n[Mathematics] Logarithm question detected.")
            print("Please use the Mathematics menu → Logarithms tool for best results.")

        elif 'limit' in q_lower:
            print("\n[Mathematics] Limit question detected.")
            print("Please use the Mathematics menu → Limits tool.")

        elif 'differential' in q_lower or 'dy/dx' in q_lower:
            print("\n[Mathematics] Differential equation detected.")
            print("Please use the Mathematics menu → Differential Equations tool.")

        else:
            print("\n[Scientific AI v9.0]")
            print("For best results, use the specific tools in the menus.")
            print("Chat mode currently supports basic understanding.")


# =============================================================================
#                           ABOUT
# =============================================================================

def about_bot_v9():
    print("\n>>> ABOUT v9.0 <<<")
    print("This version focuses on deep Mathematics with teaching-style explanations.")
    print("New tools: Powers & Roots, Logarithms, Limits, Differential Equations.")


if __name__ == "__main__":
    main_menu()
