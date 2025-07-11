import argparse
import os

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--message', type=str, required=True, help='The message to print.')
    
    args = parser.parse_args()
    print(f"Message: {args.message}")

if __name__ == "__main__":
    main()

    # Create output directory
    os.makedirs('output_message', exist_ok=True)
