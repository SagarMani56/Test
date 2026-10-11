const pptxgen = require("pptxgenjs");
const { applyTheme } = require("/mnt/skills/public/pptx/scripts/apply_theme.js");
const THEME = { name: "AcmeIDP", headFontFace: "Calibri", bodyFontFace: "Calibri",
  colors: { dk1:"1B2430", lt1:"FFFFFF", dk2:"0F3D4C", lt2:"F2F6F7", accent1:"0E9AA7", accent2:"F2A541", accent3:"3D5A80", accent4:"E4572E", accent5:"6BA292", accent6:"8D99AE", hlink:"0E9AA7", folHlink:"8D99AE" } };
const pres = new pptxgen(); pres.layout = "LAYOUT_16x9"; pres.theme = { headFontFace: "Calibri", bodyFontFace: "Calibri" };
pres.title = "Acme Internal Developer Platform"; pres.author = "Group 1";
const C = pres.SchemeColor;

pres.defineSlideMaster({ title: "TITLE_DARK", background: { color: "0F3D4C" } });
pres.defineSlideMaster({ title: "CONTENT", background: { color: "FFFFFF" },
  objects: [ { rect: { x:0, y:0, w:10, h:0.12, fill:{ color:"0E9AA7" } } } ],
  slideNumber: { x: 9.2, y: 5.25, color: "8D99AE", fontSize: 10 } });

function title(s, t) { s.addText(t, { x:0.5, y:0.3, w:9, h:0.7, fontSize:28, bold:true, color:C.text2, margin:0, isTextBox:true }); }
function card(s, x, y, w, h, head, body, color) {
  s.addShape(pres.shapes.RECTANGLE, { x, y, w, h, fill:{ color:C.background2 }, line:{ color:"E1E8EA", width:0.75 } });
  s.addShape(pres.shapes.RECTANGLE, { x, y, w:0.07, h, fill:{ color }, line:{ color } });
  s.addText(head, { x:x+0.2, y:y+0.1, w:w-0.3, h:0.35, fontSize:14, bold:true, color:C.text2, margin:0, isTextBox:true });
  s.addText(body, { x:x+0.2, y:y+0.45, w:w-0.3, h:h-0.55, fontSize:11.5, color:C.text1, margin:0, valign:"top", isTextBox:true });
}

// 1 Title
let s = pres.addSlide({ masterName:"TITLE_DARK" });
s.addText("Acme Internal Developer Platform", { x:0.7, y:1.5, w:8.6, h:1, fontSize:40, bold:true, color:C.background1, margin:0, isTextBox:true });
s.addText("From one app's solution to reusable, secure, self-service platform capabilities", { x:0.7, y:2.6, w:8.2, h:0.8, fontSize:18, color:"BFE3E6", margin:0, isTextBox:true });
s.addText("AI-Driven Cloud & DevSecOps Capstone · Advanced · Platform Engineer", { x:0.7, y:4.5, w:8.6, h:0.4, fontSize:13, color:C.accent2, margin:0, isTextBox:true });
s.addNotes("Introduce role: Platform Engineer. Goal: platform, not a single app.");

// 2 Problem
s = pres.addSlide({ masterName:"CONTENT" }); title(s, "Six problems, one root cause: no shared platform");
const probs = [["Duplicate pipelines","~100 lines of CI copied per repo"],["Duplicate Terraform","Inconsistent security per team"],["Different repo structures","Engineers can't move between teams"],["Inconsistent AI specs","Agents produce uneven output"],["Long onboarding","Days to first green pipeline"],["High maintenance","Every fix applied N times"]];
probs.forEach((p,i)=>card(s, 0.5+(i%3)*3.05, 1.3+Math.floor(i/3)*1.75, 2.85, 1.55, p[0], p[1], [C.accent4,C.accent2,C.accent3][i%3]));
s.addText("Root cause: solutions live inside applications instead of in a platform.", { x:0.5, y:4.9, w:8.6, h:0.4, fontSize:14, italic:true, color:C.text2, margin:0, isTextBox:true });

// 3 Approach
s = pres.addSlide({ masterName:"CONTENT" }); title(s, "Spec-driven AI engineering workflow");
const steps = ["Understand problem","Split into domains","Write 6 specs","AI agent generates","Review · validate · secure","Test · document · package"];
steps.forEach((t,i)=>{ const x=0.5+i*1.5;
  s.addShape(pres.shapes.OVAL,{x:x+0.45,y:1.4,w:0.6,h:0.6,fill:{color:i===2?C.accent2:C.accent1},line:{color:C.background1}});
  s.addText(String(i+1),{x:x+0.45,y:1.4,w:0.6,h:0.6,align:"center",valign:"middle",fontSize:18,bold:true,color:C.background1,margin:0,isTextBox:true});
  s.addText(t,{x:x,y:2.15,w:1.5,h:0.7,align:"center",fontSize:12,color:C.text1,margin:0,isTextBox:true}); });
s.addText([
 {text:"Specs are the primary artifact; prompts and chat logs are never stored.",options:{bullet:true,breakLine:true}},
 {text:"Specs inherit from platform-spec.md; services add only deltas.",options:{bullet:true,breakLine:true}},
 {text:"AI output passes the same gates as human code, plus a human line-by-line review.",options:{bullet:true}}],
 { x:0.8, y:3.3, w:8.4, h:1.6, fontSize:15, color:C.text1, paraSpaceAfter:8, valign:"top", isTextBox:true });

// 4 Architecture
s = pres.addSlide({ masterName:"CONTENT" }); title(s, "Platform architecture");
const boxes = [["AI Specs ×6","Source of truth",C.accent2,0.5,1.4],["Reusable Workflows","ci · terraform · release",C.accent1,3.6,1.4],["Terraform Modules","6 modules + app-platform",C.accent3,6.7,1.4],["Service Template","Scaffolder + golden path",C.accent5,0.5,3.2],["Policies","Checkov · Gitleaks · Trivy",C.accent4,3.6,3.2],["App Teams","IMS · Orders · …",C.accent6,6.7,3.2]];
boxes.forEach(b=>{ s.addShape(pres.shapes.ROUNDED_RECTANGLE,{x:b[3],y:b[4],w:2.8,h:1.3,fill:{color:b[2]},line:{color:b[2]},rectRadius:0.1});
  s.addText([{text:b[0],options:{bold:true,fontSize:16,breakLine:true}},{text:b[1],options:{fontSize:12}}],{x:b[3],y:b[4],w:2.8,h:1.3,align:"center",valign:"middle",color:C.background1,margin:0.05,isTextBox:true}); });
s.addText("Teams consume versioned references (@v1, ?ref=v1) — fix once, upgrade everywhere.",{x:0.5,y:4.8,w:9,h:0.4,fontSize:13,italic:true,color:C.text2,margin:0,isTextBox:true});

// 5 Specs
s = pres.addSlide({ masterName:"CONTENT" }); title(s, "Six AI Engineering Specifications");
const rows = [["Spec","Governs","Key acceptance criterion"],
["platform-spec","Vision, domains, NFRs","Team B onboarded with 0 copied pipelines/TF"],
["terraform-modules-spec","6 modules, tagging, security defaults","Checkov clean; onboarding = 1 module block"],
["workflow-spec","Reusable GitHub Actions","Caller ≤ 20 lines; least-privilege permissions"],
["repo-template-spec","Layout + scaffolder","Scaffolded repo tests & builds out of the box"],
["governance-spec","Scans, exceptions, AI policy","Seeded secret / open SG fails pipeline"],
["developer-experience-spec","Self-service, docs, metrics","Green CI < 30 min for new team"]];
s.addTable(rows.map((r,i)=>r.map(c=>({text:c,options:{bold:i===0,color:i===0?C.background1:C.text1,fill:{color:i===0?C.text2:(i%2?C.background1:C.background2)},fontSize:11.5}}))),
 { x:0.5, y:1.2, w:9, colW:[2.3,2.9,3.8], rowH:0.46, border:{type:"solid",color:"E1E8EA",pt:0.75}, valign:"middle" });

// 6 Reuse proof
s = pres.addSlide({ masterName:"CONTENT" }); title(s, "Reuse proof: before vs. after");
const m = [["CI/CD YAML per repo","~100 lines","≤ 15 lines"],["Terraform for baseline infra","~300 lines","8 lines"],["Time to first green pipeline","Days","< 30 min"],["Local validation","Many steps","make validate"]];
m.forEach((r,i)=>{ const y=1.3+i*0.85;
 s.addText(r[0],{x:0.5,y,w:3.6,h:0.7,fontSize:15,bold:true,color:C.text2,valign:"middle",margin:0,isTextBox:true});
 s.addShape(pres.shapes.ROUNDED_RECTANGLE,{x:4.3,y:y+0.05,w:2.2,h:0.6,fill:{color:"F9DDD5"},line:{color:"F9DDD5"},rectRadius:0.08});
 s.addText(r[1],{x:4.3,y:y+0.05,w:2.2,h:0.6,align:"center",valign:"middle",fontSize:14,color:C.accent4,bold:true,margin:0,isTextBox:true});
 s.addText("→",{x:6.55,y,w:0.4,h:0.7,align:"center",valign:"middle",fontSize:20,color:C.accent6,margin:0,isTextBox:true});
 s.addShape(pres.shapes.ROUNDED_RECTANGLE,{x:7.0,y:y+0.05,w:2.5,h:0.6,fill:{color:"D6EFF1"},line:{color:"D6EFF1"},rectRadius:0.08});
 s.addText(r[2],{x:7.0,y:y+0.05,w:2.5,h:0.6,align:"center",valign:"middle",fontSize:14,color:C.accent1,bold:true,margin:0,isTextBox:true}); });
s.addText("IMS and Orders (Team B) differ only by app_name, team and image-name.",{x:0.5,y:4.85,w:9,h:0.4,fontSize:13,italic:true,color:C.text2,margin:0,isTextBox:true});
s.addNotes("Targets are design goals; replace with measured numbers from your demo run.");

// 7 Security
s = pres.addSlide({ masterName:"CONTENT" }); title(s, "Security & governance: fail closed");
[["Gitleaks","Secrets in full git history",C.accent4],["Trivy","HIGH/CRITICAL CVEs in deps + image",C.accent2],["Checkov","IaC misconfiguration",C.accent3],["Coverage ≥ 80%","pytest-cov gate",C.accent5],["OIDC, no keys","Short-lived AWS credentials",C.accent1],["Exceptions","Justified · owned · expiring",C.accent6]]
 .forEach((p,i)=>card(s, 0.5+(i%3)*3.05, 1.3+Math.floor(i/3)*1.75, 2.85, 1.55, p[0], p[1], p[2]));
s.addText("Every AI-generated artifact passes the same gates; humans review every line.",{x:0.5,y:4.9,w:9,h:0.4,fontSize:14,italic:true,color:C.text2,margin:0,isTextBox:true});

// 8 Validation
s = pres.addSlide({ masterName:"CONTENT" }); title(s, "Validating AI-generated output");
s.addText([
 {text:"Executed: app lint + 5 tests (91% coverage), scaffolder happy + failure path, workflow YAML parsing.",options:{bullet:true,breakLine:true}},
 {text:"Pipeline-verified: terraform fmt/validate, Checkov, Trivy, Gitleaks, LocalStack apply/destroy.",options:{bullet:true,breakLine:true}},
 {text:"Negative tests: fake AWS key and open SSH rule must break the build.",options:{bullet:true,breakLine:true}},
 {text:"Review checklist: hallucinated actions/providers, pinned versions, least-privilege IAM, no hardcoded values.",options:{bullet:true,breakLine:true}},
 {text:"Add screenshots of your own runs from docs/VALIDATION.md here.",options:{bullet:true}}],
 { x:0.6, y:1.3, w:8.8, h:3.4, fontSize:16, color:C.text1, paraSpaceAfter:10, valign:"top", isTextBox:true });

// 9 Roadmap
s = pres.addSlide({ masterName:"CONTENT" }); title(s, "Roadmap & key decisions");
card(s,0.5,1.3,4.3,3.3,"Next 90 days","Backstage software templates at >10 teams\nPolicy-as-code (OPA/Conftest)\nDORA metrics dashboard\nSHA-pinned actions via Dependabot\nEKS golden path",C.accent1);
card(s,5.1,1.3,4.4,3.3,"Architecture decisions (ADRs)","001 Reusable workflows\n002 Two-tier Terraform modules\n003 Local-first validation (LocalStack)\n004 Security baseline + exceptions\n005 Script scaffolder before portal\n006 AI specs as primary artifact",C.accent2);

// 10 Close
s = pres.addSlide({ masterName:"TITLE_DARK" });
s.addText("One platform. Many teams. Fix once, benefit everywhere.",{x:0.7,y:1.8,w:8.6,h:1.2,fontSize:34,bold:true,color:C.background1,margin:0,isTextBox:true});
s.addText("Questions?",{x:0.7,y:3.4,w:8,h:0.5,fontSize:20,color:C.accent2,margin:0,isTextBox:true});

(async()=>{ await pres.writeFile({fileName:"Acme_IDP_Capstone.pptx"}); await applyTheme("Acme_IDP_Capstone.pptx", THEME); console.log("done"); })();
