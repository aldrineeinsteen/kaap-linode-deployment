
from pulsar import Function

class AnagramFunction(Function):

    def is_anagram(self, word1, word2):
        return sorted(word1.lower()) == sorted(word2.lower())

    def process(self, input, context):
        words = input.split(',')
        if len(words) != 2:
            context.get_logger().error("Invalid format, expected 'word1,word2'")
            return

        word1, word2 = words[0].strip(), words[1].strip()
        topic = 'persistent://public/default/anagrams-output' if self.is_anagram(word1, word2) else 'persistent://public/default/non-anagrams-output'

        context.publish(topic, input.encode('utf-8'))