import random

def generate_question(topics, difficulty):
    """Generates a random question based on the given topics and difficulty.

    Args:
        topics: A list of topics to choose from.
        difficulty: The desired difficulty level (easy, medium, or hard).

    Returns:
        A tuple containing the question, options, answer, topics, and difficulty.
    """

    # Choose a random topic
    topic = random.choice(topics)

    # Generate a random question based on the topic
    if topic == "Microprocessor":
        question = random.choice([
            "What is the function of the accumulator in 8085?",
            "Explain the role of the stack pointer in 8085.",
            "What is the difference between immediate addressing and direct addressing?",
            "How do interrupts work in 8085?",
            "Describe the instruction cycle in 8085.",
        ])
    elif topic == "Operating Systems":
        question = random.choice([
            "What is the difference between a process and a thread?",
            "Explain the concept of virtual memory.",
            "What are the different types of scheduling algorithms?",
            "How does a file system work?",
            "What is the role of a device driver?",
        ])
    # ... (add more topics and questions as needed)

    # Generate random options
    options = []
    for i in range(4):
        options.append(chr(ord('a') + i))

    # Choose a random correct answer
    correct_answer = random.choice(options)

    return (question, options, correct_answer, [topic], difficulty)

def main():
    topics = ["Microprocessor", "Operating Systems", "Networking", "Data Structures", "Algorithms"]
    difficulties = ["easy", "medium", "hard"]

    for i in range(100):
        question, options, answer, topics, difficulty = generate_question(topics, random.choice(difficulties))
        print(f"id,updated_at,user_id,question,option1,option2,option3,option4,answer,topics,difficulty")
        print(f"random_id,{datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')},user_id,{question},{options[0]},{options[1]},{options[2]},{options[3]},{answer},{topics},{difficulty}")

if __name__ == "__main__":
    main()