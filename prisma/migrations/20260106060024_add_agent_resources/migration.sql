-- CreateEnum
CREATE TYPE "ResourceType" AS ENUM ('TEXT', 'LINK', 'SMART_CONTRACT');

-- CreateTable
CREATE TABLE "AgentResource" (
    "id" TEXT NOT NULL,
    "creatorId" INTEGER NOT NULL,
    "type" "ResourceType" NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AgentResource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgentResourceMap" (
    "agentId" TEXT NOT NULL,
    "resourceId" TEXT NOT NULL,

    CONSTRAINT "AgentResourceMap_pkey" PRIMARY KEY ("agentId","resourceId")
);

-- AddForeignKey
ALTER TABLE "AgentResource" ADD CONSTRAINT "AgentResource_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "Creator"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentResourceMap" ADD CONSTRAINT "AgentResourceMap_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES "AIAgents"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgentResourceMap" ADD CONSTRAINT "AgentResourceMap_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "AgentResource"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
