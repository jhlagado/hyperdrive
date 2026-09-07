// Adapted from Caverns80 v0.1.1, GPL-3.0.
// Development-only BDOS adapter. Real CP/M integration is a separate gate.
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createZ80Runtime} from '@jhlagado/debug80-runtime/z80/runtime';

export async function createMachine({files:initialFiles={},diskFault,readOnlyFiles=[],readOnlyDrive=false,autoPage=true}={}){
 const binary=await readFile(new URL('../../build/HYPERDRV.COM',import.meta.url));
 const symbols=JSON.parse(await readFile(new URL('../../build/symbols.json',import.meta.url),'utf8'));
 const initial=new Uint8Array(65536); initial.set(binary,256);
 const runtime=createZ80Runtime({memory:initial,startAddress:256},0);
 runtime.cpu.pc=256;
 const memory=runtime.hardware.memory,cpu=runtime.cpu;
 const files=new Map(Object.entries(initialFiles).map(([name,data])=>[name,Uint8Array.from(data)]));
 const protectedFiles=new Set(readOnlyFiles);
 const diskCalls=[];const positions=new Map();let dma=128;
 const nameAt=(p)=>{const stem=Buffer.from(memory.slice(p+1,p+9).map(x=>x&127)).toString('ascii').trimEnd();const ext=Buffer.from(memory.slice(p+9,p+12).map(x=>x&127)).toString('ascii').trimEnd();return stem+(ext?'.'+ext:'');};
 let input=[],output='',instructions=0,cycles=0,exited=false,minSp=null;
 const ret=(value)=>{cpu.a=value&255;cpu.pc=memory[cpu.sp]|memory[(cpu.sp+1)&65535]<<8;cpu.sp=(cpu.sp+2)&65535;};
 function run(limit=2_000_000){
  const before={instructions,cycles,output:output.length};
  for(let i=0;i<limit;i++){
   if(cpu.pc===0){exited=true;return {...before,exited};}
   if(cpu.pc===5){
    const fn=cpu.c,address=cpu.d<<8|cpu.e;
    if(fn===0){exited=true;return {...before,exited};}
    if(fn===1){if(!input.length)return {...before,waiting:true};const ch=input.shift();output+=String.fromCharCode(ch);ret(ch);}
    else if(fn===2){output+=String.fromCharCode(cpu.e);ret(cpu.e);}
    else if(fn===6){if(cpu.e===255){if(!input.length){if(autoPage&&output.endsWith('[Space/Enter: more, Q: skip] ')){ret(32);continue;}return {...before,waiting:true};}ret(input.shift());}else{output+=String.fromCharCode(cpu.e);ret(cpu.e);}}
    else if(fn===9){let p=address;while(memory[p]!==36){assert(p<65535,'unterminated BDOS string');output+=String.fromCharCode(memory[p++]);}ret(0);}
    else if(fn===10){const eol=input.indexOf(13);if(eol<0)return {...before,waiting:true};const line=input.splice(0,eol+1).slice(0,-1);assert(line.length<=memory[address],'adapter line capacity');memory[address+1]=line.length;memory.set(line,address+2);output+=String.fromCharCode(...line)+'\r\n';ret(0);}
    else if([15,16,19,20,21,22,23,25,26,29].includes(fn)){
     const name=nameAt(address);diskCalls.push({fn,name,address});
     const occurrence=diskCalls.filter(c=>c.fn===fn).length;
     const failed=diskFault?.fn===fn&&occurrence===(diskFault.occurrence??1);
     if(failed&&!diskFault.afterEffect){ret(diskFault.status??255);continue;}
     let status=0;
     if(fn===15){if(files.has(name)){positions.set(address,0);if(protectedFiles.has(name))memory[address+9]|=128;}else status=255;}
     if(fn===16){if(!files.has(name))status=255;}
     if(fn===19){assert(!protectedFiles.has(name),'BDOS file read-only abort must be prevented');if(!files.delete(name))status=255;}
     if(fn===20){const data=files.get(name),position=positions.get(address)??0;if(!data||position>=data.length)status=1;else{memory.fill(26,dma,dma+128);memory.set(data.slice(position,position+128),dma);positions.set(address,position+128);}}
     if(fn===21){if(!files.has(name))status=1;else{const old=files.get(name),position=positions.get(address)??0;const data=new Uint8Array(Math.max(old.length,position+128));data.set(old);data.set(memory.slice(dma,dma+128),position);files.set(name,data);positions.set(address,position+128);}}
     if(fn===22){if(files.has(name))status=255;else{files.set(name,new Uint8Array());positions.set(address,0);}}
     if(fn===23){assert(!protectedFiles.has(name),'BDOS file read-only abort must be prevented');const target=nameAt(address+16);if(!files.has(name)||files.has(target))status=255;else{files.set(target,files.get(name));files.delete(name);}}
     if(fn===26)dma=address;
     if(fn===29){cpu.h=0;cpu.l=readOnlyDrive?1:0;}
     ret(failed?(diskFault.status??255):status);
    }else throw new Error(`Unsupported BDOS function ${fn}`);
   }else{const step=runtime.step();instructions++;cycles+=step.cycles??0;if(minSp!==null)minSp=Math.min(minSp,cpu.sp);else if(cpu.sp===symbols.STACKTOP)minSp=cpu.sp;}
  }
  throw new Error(`Execution budget exceeded at ${cpu.pc.toString(16)} after ${instructions} instructions; output: ${output.slice(-500)}`);
 }
 return {runtime,memory,symbols,run,files,diskCalls,get dma(){return dma},get output(){return output},get exited(){return exited},get metrics(){return {instructions,cycles,minSp}},
  byte(name){assert(name in symbols,`unknown symbol ${name}`);return memory[symbols[name]];},
  send(text){input.push(...Buffer.from(text,'ascii'));return run();},
  command(text){const start=output.length;input.push(...Buffer.from(text+'\r','ascii'));run();return output.slice(start);}};
}
