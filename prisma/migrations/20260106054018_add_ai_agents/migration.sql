-- CreateEnum
CREATE TYPE "ModelProvider" AS ENUM ('openai', 'anthropic', 'gemini', 'qwen', 'deepseek');

-- CreateTable
CREATE TABLE "AIAgents" (
    "id" TEXT NOT NULL,
    "creatorId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "modelProvider" "ModelProvider" NOT NULL,
    "modelName" TEXT NOT NULL,
    "systemPrompt" TEXT NOT NULL,
    "pricePerHit" DOUBLE PRECISION NOT NULL,
    "isActive" BOOLEAN NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AIAgents_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "AIAgents_slug_key" ON "AIAgents"("slug");

-- AddForeignKey
ALTER TABLE "AIAgents" ADD CONSTRAINT "AIAgents_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "Creator"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
