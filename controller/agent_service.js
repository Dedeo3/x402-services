import dotenv from "dotenv";
dotenv.config();

// if (!process.env.GEMINI_API_KEY) {
//   throw new Error("GEMINI_API_KEY is missing. Set it in .env");
// }

import { GoogleGenerativeAI } from "@google/generative-ai";
import readlineSync from "readline-sync";

const genAi = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAi.getGenerativeModel({model: "gemini-2.5-flash" })

export const chat = async (prompt) => {
    try {
        const result = await model.generateContent(prompt);
        return result.response.text();
    } catch (error) {
        console.error("Chat Error:", error);
        throw error;
    }
};
