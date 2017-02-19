// http://stackoverflow.com/questions/30195204/how-to-parse-llvm-ir-line-by-line
// http://llvm.org/docs/doxygen/html/InstCount_8cpp_source.html
#include <iostream>
#include <string>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/ErrorOr.h>
#include <llvm/Pass.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/InstVisitor.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Instructions.h>
#include <llvm/Bitcode/ReaderWriter.h>
#include <llvm/Support/raw_ostream.h>

using namespace llvm;

namespace{
class InstCountPass : public FunctionPass, public InstVisitor<InstCountPass> {
  friend class InstVisitor<InstCountPass>;

  void visitFunction(Function &F) { 
    ++TotalFuncs;
  }
  void visitBasicBlock(BasicBlock &BB) { 
    ++TotalBlocks; 
  }

#define HANDLE_INST(N, OPCODE, CLASS) \
  void visit##OPCODE(CLASS &) { ++Num##OPCODE##Inst; ++TotalInsts; }
#include <llvm/IR/Instruction.def>
  
  void visitInstruction(Instruction &I) {
    errs() << "Instruction Count does not know about " << I;
    llvm_unreachable(nullptr);
  }
public:
  static char ID;
  InstCountPass():FunctionPass(ID) { }
  
  virtual bool runOnFunction(Function &F);

  int TotalInsts = 0;
  int TotalFuncs = 0;
  int TotalBlocks = 0;
#define HANDLE_INST(N, OPCODE, CLASS) \
  int Num##OPCODE##Inst = 0;
#include <llvm/IR/Instruction.def>
};

bool InstCountPass::runOnFunction(Function &F) {
  visit(F);
  return false;
}
}

char InstCountPass::ID = 0;
static RegisterPass<InstCountPass> X("hello", "Hello World Pass",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);

int main(int argc, char *argv[]){
  if (argc != 2) {
    std::cerr << "Usage : " << argv[0] << " <.bc file>" << std::endl;
    return 1;
  }

  StringRef filename = argv[1];
  LLVMContext context;

  ErrorOr<std::unique_ptr<MemoryBuffer>> fileOrErr = 
    MemoryBuffer::getFileOrSTDIN(filename);
  if (std::error_code ec = fileOrErr.getError()) {
    std::cerr << "Error opening input file: " + ec.message() << std::endl;
    return 2;
  }
  ErrorOr<std::unique_ptr<llvm::Module>> moduleOrErr = 
    parseBitcodeFile(fileOrErr.get()->getMemBufferRef(), context);
  if (std::error_code ec = fileOrErr.getError()) {
    std::cerr << "Error reading module : " + ec.message() << std::endl;
    return 3;
  }

  std::unique_ptr<Module> m = std::move(moduleOrErr.get());
  std::cout << "Successfully read Module : " << std::endl;
  std::cout << "\tName : " << m->getName().str() << std::endl;
  std::cout << "\tTarget triple : " << m->getTargetTriple() << std::endl;
  
  InstCountPass *ip = new InstCountPass();
  for (auto fitr = m->getFunctionList().begin(); 
      fitr != m->getFunctionList().end(); fitr++) {
    Function &f = *fitr;
    ip->runOnFunction(f);
  }
  std::cout << "Result : " << std::endl;
  std::cout << "\tTotal Inst # : " << ip->TotalInsts << std::endl;
  std::cout << "\tFreeze Inst # :  "<< ip->NumFreezeInst << std::endl;
  return 0;
}
