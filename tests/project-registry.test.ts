import { describe, it, expect, beforeEach, vi } from "vitest";

// Mock contract interface
type Principal = string;
type Buff32 = string;
type Project = {
  owner: Principal;
  title: string;
  desc: string;
  loc: string;
  goals: string[];
  created: number;
};

const mockBlockHeight = 12345;
const mockSender = "ST1234MOCKSENDER";
const mockProjectHash = "0x" + "ab".repeat(32);

let projects: Record<Buff32, Project> = {};

function registerProject(
  hash: Buff32,
  title: string,
  desc: string,
  loc: string,
  goals: string[],
  sender: Principal
) {
  if (projects[hash]) throw new Error("Already registered");
  if (!title || !desc || !loc || goals.length === 0) throw new Error("Invalid");
  projects[hash] = {
    owner: sender,
    title,
    desc,
    loc,
    goals,
    created: mockBlockHeight,
  };
  return true;
}

function transfer(hash: Buff32, to: Principal, sender: Principal) {
  const p = projects[hash];
  if (!p) throw new Error("Not found");
  if (p.owner !== sender) throw new Error("Not owner");
  p.owner = to;
  return true;
}

describe("Project Registry Contract", () => {
  beforeEach(() => {
    projects = {};
  });

  it("registers a project", () => {
    const result = registerProject(
      mockProjectHash,
      "Rewilding Project",
      "Restore native habitat",
      "Location X",
      ["Goal 1", "Goal 2"],
      mockSender
    );
    expect(result).toBe(true);
    expect(projects[mockProjectHash].title).toBe("Rewilding Project");
  });

  it("prevents duplicate registration", () => {
    registerProject(
      mockProjectHash,
      "Rewilding Project",
      "Restore native habitat",
      "Location X",
      ["Goal 1", "Goal 2"],
      mockSender
    );
    expect(() =>
      registerProject(
        mockProjectHash,
        "Another Project",
        "Desc",
        "Loc",
        ["Goal"],
        mockSender
      )
    ).toThrow("Already registered");
  });

  it("transfers ownership", () => {
    registerProject(
      mockProjectHash,
      "Rewilding Project",
      "Restore native habitat",
      "Location X",
      ["Goal 1", "Goal 2"],
      mockSender
    );
    const newOwner = "STNEWOWNER";
    const result = transfer(mockProjectHash, newOwner, mockSender);
    expect(result).toBe(true);
    expect(projects[mockProjectHash].owner).toBe(newOwner);
  });

  it("prevents transfer by non-owner", () => {
    registerProject(
      mockProjectHash,
      "Rewilding Project",
      "Restore native habitat",
      "Location X",
      ["Goal 1", "Goal 2"],
      mockSender
    );
    expect(() =>
      transfer(mockProjectHash, "STNEWOWNER", "STNOTOWNER")
    ).toThrow("Not owner");
  });

  it("throws error if project not found on transfer", () => {
    expect(() =>
      transfer("0x" + "cd".repeat(32), "STNEWOWNER", mockSender)
    ).toThrow("Not found");
  });
});