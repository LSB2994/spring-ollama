package com.example.spring_ollama;

import org.springframework.ai.chat.model.ChatModel;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin
public class CharController {

    private final ChatModel chatModel;

    public CharController(ChatModel chatModel) {
        this.chatModel = chatModel;
    }

    @GetMapping("/test-model")
    public String testModel() {
        try {
            return "Model test: " + chatModel.call("test message");
        } catch (Exception e) {
            return "Model error: " + e.getMessage();
        }
    }

    @GetMapping
    public String getChar() {
        return "Hello World";
    }

    @PostMapping("/chat")
    public ResponseEntity<String> prompt(@RequestParam String m) {
        try {
            return ResponseEntity.ok(chatModel.call(m));
        } catch (Exception e) {
            // Log the specific error
            System.err.println("Error in chat endpoint: " + e.getMessage());
            e.printStackTrace();

            // Return a proper error response
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error processing request: " + e.getMessage());
        }
    }
}
