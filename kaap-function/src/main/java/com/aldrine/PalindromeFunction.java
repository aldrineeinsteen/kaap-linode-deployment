package com.aldrine;

import org.apache.pulsar.functions.api.Context;
import org.apache.pulsar.functions.api.Function;

public class PalindromeFunction implements Function<String, Void> {

    private boolean isPalindrome(String word) {
        String cleaned = word.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
        return cleaned.equals(new StringBuilder(cleaned).reverse().toString());
    }

    @Override
    public Void process(String input, Context context) throws Exception {
        if (input == null || input.isEmpty()) {
            context.getLogger().error("Received empty input.");
            return null;
        }

        String topic = isPalindrome(input)
                ? "persistent://public/default/palindromes-output"
                : "persistent://public/default/non-palindromes-output";

        context.publish(topic, input.getBytes());
        return null;
    }
}