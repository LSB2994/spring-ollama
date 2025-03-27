package com.example.spring_ollama;

import org.springframework.ai.chat.model.ChatModel;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
public class CharController {

    private final ChatModel chatModel;

    public CharController(ChatModel chatModel) {
        this.chatModel = chatModel;
    }

    @GetMapping("/chat")
    public String prompt(@RequestParam String m){
        return chatModel.call(m);
    }
}
