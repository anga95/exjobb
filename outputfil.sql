-- Schema: ANDRE
CREATE SCHEMA ANDRE;

-- Table: ANDRE.TABLE1
CREATE TABLE ANDRE.TABLE1 (
  ID INTEGER NOT NULL,
  NAME VARCHAR(255),
  PRIMARY KEY (ID),
  UNIQUE (ID));

-- Schema: SYSTOOLS
CREATE SCHEMA SYSTOOLS;

-- Table: SYSTOOLS.POLICY
CREATE TABLE SYSTOOLS.POLICY (
  MED VARCHAR(128) NOT NULL,
  DECISION VARCHAR(128) NOT NULL,
  NAME VARCHAR(128) NOT NULL,
  UPDATE_TIME TIMESTAMP NOT NULL,
  POLICY BLOB,
  UNIQUE (MED),
  UNIQUE (DECISION),
  UNIQUE (NAME));

-- View: ANDRE.TABLE1VIEW
CREATE VIEW ANDRE.TABLE1VIEW AS CREATE VIEW ANDRE.table1view AS
SELECT name
FROM TABLE1;

-- Schema: SYSCAT
CREATE SCHEMA SYSCAT;

-- View: SYSCAT.ATTRIBUTES
CREATE VIEW SYSCAT.ATTRIBUTES AS create or replace view syscat.attributes 
(typeschema, typemodulename, typename, attr_name, attr_typeschema, 
attr_typemodulename, attr_typename, target_typeschema, target_typemodulename, 
target_typename, source_typeschema, source_typemodulename, source_typename, 
ordinal, length, scale, typestringunits, stringunitslength, codepage, 
collationschema, collationname, logged, compact, dl_features, java_fieldname, 
envstringunits) 
as select 
a.typeschema, m.modulename, a.typename, a.attr_name, a.attr_typeschema, 
ma.modulename, a.attr_typename, a.target_typeschema, mt.modulename, 
a.target_typename, a.source_typeschema, ms.modulename, a.source_typename, 
a.ordinal, a.length, 
CASE WHEN (a.codepage=1208 or a.codepage=1200) and a.scale<>0 THEN CAST(0 as 
SMALLINT) 
ELSE a.scale END, 
CASE WHEN a.codepage=1208 and a.scale=0 THEN CAST('OCTETS' as VARCHAR(11)) 
WHEN a.codepage=1208 and a.scale=4 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
WHEN a.codepage=1200 and a.scale=0 THEN CAST('CODEUNITS16' as 
VARCHAR(11)) 
WHEN a.codepage=1200 and a.scale=2 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
ELSE CAST(NULL AS VARCHAR(11)) END, 
CASE WHEN (a.codepage=1208 or a.codepage=1200) and a.scale=0 THEN a.length 
WHEN (a.codepage=1208 or a.codepage=1200) and a.scale<>0 THEN 
CAST(a.length/a.scale as INTEGER) 
ELSE CAST(NULL AS INTEGER) END, 
a.codepage, 
case when a.collationid is null then null 
else coalesce(c.collationschema, 'SYSIBM') end, 
case when a.collationid is null then null 
else coalesce(c.collationname, syscat.collationname(a.collationid)) end, 
a.logged, a.compact, 
coalesce(sysibm.deprecatedchar('-206', 'COLUMN', 
'SYSCAT.ATTRIBUTES.DL_FEATURES'), 
cast ('          ' as char(10))), 
a.java_fieldname, 
cast(case 
when a.stringunits = 'S' then 'SYSTEM' 
when a.stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)) 
from sysibm.sysattributes as a 
inner join sysibm.sysdatatypes as d on d.metatype <> 'F' and 
a.typename = d.name and a.typeschema = d.schema and 
(a.typemoduleid = d.typemoduleid or 
a.typemoduleid is null and d.typemoduleid is null) 
left outer join sysibm.syscollations as c on a.collationid = c.collationid 
left outer join sysibm.sysmodules m  on a.typemoduleid=m.moduleid 
left outer join sysibm.sysmodules ma on a.attr_typemoduleid=ma.moduleid 
left outer join sysibm.sysmodules mt on a.target_typemoduleid=mt.moduleid 
left outer join sysibm.sysmodules ms on a.source_typemoduleid=ms.moduleid 

;

-- View: SYSCAT.AUDITPOLICIES
CREATE VIEW SYSCAT.AUDITPOLICIES AS create or replace view syscat.auditpolicies 
(auditpolicyname, auditpolicyid, create_time, alter_time, 
auditstatus, contextstatus, validatestatus, checkingstatus, 
secmaintstatus, objmaintstatus, sysadminstatus, executestatus, 
executewithdata, errortype, remarks) 
as select 
a.auditpolicyname, a.auditpolicyid, a.create_time, 
a.alter_time, a.auditstatus, a.contextstatus, a.validatestatus, 
a.checkingstatus, a.secmaintstatus, a.objmaintstatus, 
a.sysadminstatus, a.executestatus, a.executewithdata, 
a.errortype, b.remarks 
from sysibm.sysauditpolicies as a left outer join sysibm.syscomments as b 
on a.auditpolicyid = b.objectid and b.objecttype='j'
;

-- View: SYSCAT.AUDITUSE
CREATE VIEW SYSCAT.AUDITUSE AS create or replace view syscat.audituse 
(auditpolicyname, auditpolicyid, objecttype, 
subobjecttype, objectschema, objectname, auditexceptionenabled) 
as select 
a.auditpolicyname, a.auditpolicyid, cast('x' as char(1)), 
cast(' ' as char(1)), cast (null as char(1)), b.contextname, 
b.auditexceptionenabled 
from sysibm.sysauditpolicies a, sysibm.syscontexts b 
where b.auditpolicyid is not null 
and a.auditpolicyid = b.auditpolicyid 
union all 
select a.auditpolicyname, a.auditpolicyid, c.objecttype, 
c.subobjecttype, cast (null as char(1)), c.objectname, 
c.auditexceptionenabled 
from sysibm.sysauditpolicies a, sysibm.sysaudituse c 
where a.auditpolicyid = c.auditpolicyid 
union all 
select a.auditpolicyname, a.auditpolicyid, 
cast('i' as char(1)), cast('R' as char(1)), cast (null as char(1)), 
d.rolename, d.auditexceptionenabled 
from sysibm.sysauditpolicies a, sysibm.sysroles d 
where d.auditpolicyid is not null 
and a.auditpolicyid = d.auditpolicyid 
union all 
select a.auditpolicyname, a.auditpolicyid, e.type, 
cast(' ' as char(1)), e.creator, e.name, e.auditexceptionenabled 
from sysibm.sysauditpolicies a, sysibm.systables e 
where e.auditpolicyid is not null 
and a.auditpolicyid = e.auditpolicyid 
union all 
select a.auditpolicyname, a.auditpolicyid, 
cast('?' as char(1)), cast(' ' as char(1)), 
cast(null as char(1)), f.name, f.auditexceptionenabled 
from sysibm.sysauditpolicies a, sysibm.sysschemata f 
where f.auditpolicyid is not null 
and a.auditpolicyid = f.auditpolicyid 

;

-- View: SYSCAT.BUFFERPOOLDBPARTITIONS
CREATE VIEW SYSCAT.BUFFERPOOLDBPARTITIONS AS create or replace view syscat.bufferpooldbpartitions 
(bufferpoolid, dbpartitionnum, npages) 
as select 
bufferpoolid, nodenum, npages 
from sysibm.sysbufferpoolnodes
;

-- View: SYSCAT.BUFFERPOOLEXCEPTIONS
CREATE VIEW SYSCAT.BUFFERPOOLEXCEPTIONS AS create or replace view syscat.bufferpoolexceptions 
(bufferpoolid, member, npages) 
as select 
bufferpoolid, nodenum, npages 
from sysibm.sysbufferpoolnodes
;

-- View: SYSCAT.BUFFERPOOLNODES
CREATE VIEW SYSCAT.BUFFERPOOLNODES AS create or replace view syscat.bufferpoolnodes 
(bufferpoolid, nodenum, npages) 
as select 
bufferpoolid, nodenum, npages 
from sysibm.sysbufferpoolnodes
;

-- View: SYSCAT.BUFFERPOOLS
CREATE VIEW SYSCAT.BUFFERPOOLS AS create or replace view syscat.bufferpools 
(bpname, bufferpoolid, dbpgname, npages, pagesize, estore, 
numblockpages, blocksize, ngname) 
as select 
bpname, bufferpoolid, ngname, npages, pagesize, cast('N' as char(1)), 
numblockpages, blocksize, ngname 
from sysibm.sysbufferpools
;

-- View: SYSCAT.CASTFUNCTIONS
CREATE VIEW SYSCAT.CASTFUNCTIONS AS create or replace view syscat.castfunctions 
(from_typeschema, from_typemodulename, from_typename, from_typemoduleid, 
to_typeschema, to_typemodulename, to_typename, to_typemoduleid, 
funcschema, funcmodulename, funcname, specificname, funcmoduleid, 
assign_function) 
as select 
p1.typeschema, m1.modulename, p1.typename, p1.typemoduleid, 
p2.typeschema, m2.modulename, p2.typename, p2.typemoduleid, 
f.routineschema, m.modulename, f.routinename, f.specificname, 
f.routinemoduleid, f.assign_function 
from 
(sysibm.sysroutines as f left outer join sysibm.sysmodules m on 
f.routinemoduleid = m.moduleid), 
(sysibm.sysroutineparms as p1 left outer join sysibm.sysmodules m1 on 
p1.typemoduleid = m1.moduleid), 
(sysibm.sysroutineparms as p2 left outer join sysibm.sysmodules m2 on 
p2.typemoduleid = m2.moduleid) 
where 
f.cast_function = 'Y' 
and f.routine_id = p1.routine_id 
and f.routine_id = p2.routine_id 
and f.routinetype in ('F', 'M') 
and f.routineschema not in ('SYSIBMINTERNAL') 
and p1.rowtype = 'P' 
and p1.ordinal = 1 
and p2.rowtype = 'C' 
and p2.ordinal = 0
;

-- View: SYSCAT.CHECKS
CREATE VIEW SYSCAT.CHECKS AS create or replace view syscat.checks 
(constname, owner, ownertype, tabschema, tabname, create_time, 
qualifier, type, func_path, text, percentvalid, collationschema, 
collationname, collationschema_orderby, collationname_orderby, definer, 
envstringunits) 
as select 
name, definer, definertype, tbcreator, tbname, create_time, 
qualifier, type,  func_path, text, percentvalid, 
coalesce(c1.collationschema, 'SYSIBM'), 
coalesce(c1.collationname, syscat.collationname(x.collationid)), 
coalesce(c2.collationschema, 'SYSIBM'), 
coalesce(c2.collationname, syscat.collationname(x.collationid_orderby)), 
definer, 
cast(case 
when x.stringunits = 'S' then 'SYSTEM' 
when x.stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)) 
from sysibm.syschecks x 
left outer join sysibm.syscollations as c1 
on x.collationid = c1.collationid 
left outer join sysibm.syscollations as c2 
on x.collationid_orderby = c2.collationid
;

-- View: SYSCAT.COLAUTH
CREATE VIEW SYSCAT.COLAUTH AS create or replace view syscat.colauth 
(grantor, grantortype, grantee, granteetype, tabschema, tabname, colname, 
colno, privtype, grantable) 
as select 
grantor, grantortype, grantee, granteetype, creator, tname, colname, 
colno, privtype, grantable 
from sysibm.syscolauth
;

-- View: SYSCAT.COLCHECKS
CREATE VIEW SYSCAT.COLCHECKS AS create or replace view syscat.colchecks 
(constname, tabschema, tabname, colname, usage) 
as select 
constname,tbcreator, tbname, colname, usage 
from sysibm.syscolchecks
;

-- View: SYSCAT.COLDIST
CREATE VIEW SYSCAT.COLDIST AS create or replace view syscat.coldist 
(tabschema, tabname, colname, type, seqno, colvalue, 
valcount, distcount) 
as select 
schema, tbname, name, type, seqno, colvalue, 
valcount, distcount 
from sysibm.syscoldist
;

-- View: SYSCAT.COLGROUPCOLS
CREATE VIEW SYSCAT.COLGROUPCOLS AS create or replace view syscat.colgroupcols 
(colgroupid, colname, tabschema, tabname, ordinal) 
as select 
colgroupid, colname, tabschema, tabname, ordinal 
from sysibm.syscolgroupscols
;

-- View: SYSCAT.COLGROUPDIST
CREATE VIEW SYSCAT.COLGROUPDIST AS create or replace view syscat.colgroupdist 
(colgroupid, type, ordinal, seqno, colvalue) 
as select 
colgroupid, type, ordinal, seqno, colvalue 
from sysibm.syscolgroupdist
;

-- View: SYSCAT.COLGROUPDISTCOUNTS
CREATE VIEW SYSCAT.COLGROUPDISTCOUNTS AS create or replace view syscat.colgroupdistcounts 
(colgroupid, type, seqno, valcount, distcount) 
as select 
colgroupid, type, seqno, valcount, distcount 
from sysibm.syscolgroupdistcounts
;

-- View: SYSCAT.COLGROUPS
CREATE VIEW SYSCAT.COLGROUPS AS create or replace view syscat.colgroups 
(colgroupschema, colgroupname, colgroupid, colgroupcard, 
numfreq_values, numquantiles) 
as select 
colgroupschema, colgroupname, colgroupid, colgroupcard, 
numfreq_values, numquantiles 
from sysibm.syscolgroups
;

-- View: SYSCAT.COLIDENTATTRIBUTES
CREATE VIEW SYSCAT.COLIDENTATTRIBUTES AS create or replace view syscat.colidentattributes 
(tabschema, tabname, colname, start, increment, 
minvalue, maxvalue, cycle, cache, order, nextcachefirstvalue, seqid) 
as select 
c.tbcreator, c.tbname, c.name, s.start, 
s.increment, s.minvalue, s.maxvalue, s.cycle, 
s.cache, s.order, 
cast(case when s.lastassignedval + s.increment > s.maxvalue 
and s.increment > 0 
then case when s.cycle = 'Y' then s.minvalue else null end 
when s.lastassignedval + s.increment < s.minvalue 
and s.increment < 0 
then case when s.cycle = 'Y' then s.maxvalue else null end 
else coalesce(s.lastassignedval + s.increment, s.start) end as decimal(31)), 
s.seqid 
from sysibm.syscolumns as c, sysibm.sysdependencies as d, 
sysibm.syssequences as s 
where c.tbcreator = d.dschema and 
c.tbname = d.dname and 
d.bname = s.seqname and 
d.bschema = s.seqschema and 
c.identity = 'Y' and 
d.dtype = 'T' and 
d.btype = 'Q' and 
s.seqtype = 'I'
;

-- View: SYSCAT.COLLATIONS
CREATE VIEW SYSCAT.COLLATIONS AS create or replace view syscat.collations 
(collationschema, collationname, sourcecollationschema, 
sourcecollationname, owner, ownertype, remarks) 
as select 
c.collationschema, c.collationname, 
cast('SYSIBM' as VARCHAR(128)), 
syscat.collationname(c.sourcecollationid), 
c.owner, c.ownertype, cmnt.remarks 
from sysibm.syscollations c left outer join sysibm.syscomments cmnt 
on cmnt.objecttype='c' and c.objectid = cmnt.objectid
;

-- View: SYSCAT.COLOPTIONS
CREATE VIEW SYSCAT.COLOPTIONS AS create or replace view syscat.coloptions 
(tabschema, tabname, colname, option, setting) 
as select 
tabschema, tabname, colname, option, setting 
from sysibm.syscoloptions 
where option not in ('DEFAULT_QUALIFIER', 'DEFAULT_FUNC_PATH')
;

-- View: SYSCAT.COLUMNS
CREATE VIEW SYSCAT.COLUMNS AS create or replace view syscat.columns 
(tabschema, tabname, colname, colno, typeschema, 
typename, length, scale, typestringunits, stringunitslength, 
default, nulls, 
codepage, collationschema, collationname, logged, 
compact, colcard, high2key, low2key, avgcollen, 
keyseq, partkeyseq, nquantiles, nmostfreq, 
numnulls, target_typeschema, target_typename, 
scope_tabschema, scope_tabname, 
source_tabschema, source_tabname, 
dl_features, special_props, 
hidden, inline_length, pctinlined, identity, rowchangetimestamp, 
generated, text, compress, avgdistinctperpage, 
pagevarianceratio, sub_count, sub_delim_length, avgcollenchar, 
implicitvalue, seclabelname, rowbegin, rowend, transactionstartid, 
pctencoded, avgencodedcollen, 
qualifier, func_path, randdistkey, remarks) 
as select 
c.tbcreator, c.tbname, c.name, c.colno, c.typeschema, 
c.typename, c.longlength, 
case when (c.composite_codepage=1208 or c.composite_codepage=1200) and 
c.scale<>0 then cast (0 as SMALLINT) 
else c.scale end, 
CASE WHEN c.composite_codepage=1208 and c.scale=0 THEN CAST('OCTETS' as 
VARCHAR(11)) 
WHEN c.composite_codepage=1208 and c.scale=4 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
WHEN c.composite_codepage=1200 and c.scale=0 THEN CAST('CODEUNITS16' as 
VARCHAR(11)) 
WHEN c.composite_codepage=1200 and c.scale=2 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
ELSE CAST(NULL AS VARCHAR(11)) END, 
CASE WHEN (c.composite_codepage=1208 or c.composite_codepage=1200) and 
c.scale=0 THEN c.longlength 
WHEN (c.composite_codepage=1208 or c.composite_codepage=1200) and 
c.scale<>0 THEN CAST(c.longlength/c.scale as INTEGER) 
ELSE CAST(NULL AS INTEGER) END, 
c.default, c.nulls, 
c.composite_codepage, 
case when c.collationid is null then null 
else coalesce((select col.collationschema from sysibm.syscollations col 
where c.collationid = col.collationid), 
'SYSIBM') end, 
case when c.collationid is null then null 
else coalesce((select col.collationname from sysibm.syscollations col 
where c.collationid = col.collationid), 
syscat.collationname(c.collationid)) end, 
c.logged, c.compact, c.colcard, 
c.high2key, c.low2key, c.avgcollen, 
c.keyseq, c.partkeyseq, c.nquantiles, c.nmostfreq, 
c.numnulls, 
(select p.target_typeschema 
from sysibm.syscolproperties p 
where c.tbcreator = p.tabschema 
and c.tbname = p.tabname 
and c.name = p.colname), 
(select p.target_typename 
from sysibm.syscolproperties p 
where c.tbcreator = p.tabschema 
and c.tbname = p.tabname 
and c.name = p.colname), 
(select p.scope_tabschema 
from sysibm.syscolproperties p 
where c.tbcreator = p.tabschema 
and c.tbname = p.tabname 
and c.name = p.colname), 
(select p.scope_tabname 
from sysibm.syscolproperties p 
where c.tbcreator = p.tabschema 
and c.tbname = p.tabname 
and c.name = p.colname), 
c.source_tabschema, c.source_tabname, 
cast(coalesce(sysibm.deprecatedchar('-206', 'COLUMN', 
'SYSCAT.ATTRIBUTES.DL_FEATURES'), 
null) as char(10)), 
cast(case 
when c.coltype = 'REF' then 
(select p.special_props 
from sysibm.syscolproperties p 
where c.tbcreator = p.tabschema 
and c.tbname = p.tabname 
and c.name = p.colname) 
else null 
end as char(8)), 
c.hidden, c.inline_length, c.pctinlined, 
cast(case when c.identity = 'Y' then 'Y' 
else 'N' end as char(1)), 
cast(case when c.identity = 'T' then 'Y' 
else 'N' end as char(1)), 
c.generated, 
case 
when c.generated = ' ' then null 
else 
(select case 
when posstr(ch.text, ' =  ') = 0 
then ch.text 
else 'AS' concat 
substr(ch.text, 
posstr(ch.text, ' =  ') + 3) 
end 
from sysibm.syschecks ch, sysibm.syscolchecks cc 
where c.tbcreator = cc.tbcreator 
and c.tbname = cc.tbname 
and c.name = cc.colname 
and cc.usage = 'T' 
and cc.constname = ch.name 
and cc.tbcreator = ch.tbcreator 
and cc.tbname = ch.tbname) 
end, 
c.compress, c.avgdistinctperpage, c.pagevarianceratio, 
c.sub_count, c.sub_delim_length, c.avgcollenchar, c.implicitvalue, 
(select seclabelname 
from sysibm.syssecuritylabels where seclabelid = c.seclabelid), 
cast(case when c.identity = 'B' then 'Y' 
else 'N' 
end as char(1)), 
cast(case when c.identity = 'E' then 'Y' 
else 'N' 
end as char(1)), 
cast(case when c.identity = 'S' then 'Y' 
else 'N' 
end as char(1)), 
c.pctencoded, c.avgencodedcollen, 
(select cast(setting as varchar(128)) 
from sysibm.syscoloptions 
where tabname = c.tbname 
and tabschema = c.tbcreator 
and colname = c.name 
and option = 'DEFAULT_QUALIFIER'), 
(select cast(setting as clob(2k)) 
from sysibm.syscoloptions 
where  tabname = c.tbname 
and tabschema = c.tbcreator 
and colname = c.name 
and option = 'DEFAULT_FUNC_PATH'), 
cast(case when c.identity = 'R' then 'Y' 
else 'N' 
end as char(1)), 
c.remarks 
from sysibm.syscolumns c 

;

-- View: SYSCAT.COLUSE
CREATE VIEW SYSCAT.COLUSE AS create or replace view syscat.coluse 
(tabschema, tabname, colname, dimension, colseq, type) 
as select 
tabschema, tabname, colname, dimension, colseq, type 
from sysibm.syscoluse
;

-- View: SYSCAT.CONDITIONS
CREATE VIEW SYSCAT.CONDITIONS AS create or replace view syscat.conditions 
(condschema, condmodulename, condname, condid, condmoduleid, 
sqlstate, owner, ownertype, create_time, remarks) 
as select 
v.varschema, m.modulename, v.varname, v.varid, v.varmoduleid, 
CAST(substr(v.default,2,5) AS CHAR(5)), v.owner, v.ownertype, 
v.create_time, c.remarks 
from 
sysibm.sysvariables as v 
left outer join sysibm.sysdatatypes as d on v.typeid = d.typeid 
left outer join sysibm.sysmodules as m on v.varmoduleid = m.moduleid 
left outer join sysibm.syscomments as c 
on v.varid = c.objectid and c.objecttype = 'v' 
where d.schema = 'SYSPROC' and d.name = 'DB2SQLSTATE'
;

-- View: SYSCAT.CONSTDEP
CREATE VIEW SYSCAT.CONSTDEP AS create or replace view syscat.constdep 
(constname, tabschema, tabname, btype, bschema, bmodulename, bname, bmoduleid) 
as select 
dconstname, dtbcreator, dtbname, btype, bcreator, m.modulename, bname, 
bmoduleid 
from sysibm.sysconstdep left outer join sysibm.sysmodules m on 
bmoduleid=m.moduleid
;

-- View: SYSCAT.CONTEXTATTRIBUTES
CREATE VIEW SYSCAT.CONTEXTATTRIBUTES AS create or replace view syscat.contextattributes 
(contextname, attr_name, attr_value, attr_options) 
as  select 
b.contextname, a.attr_name, a.attr_value, a.attr_options 
from sysibm.syscontextattributes a, sysibm.syscontexts b 
where a.contextid = b.contextid
;

-- View: SYSCAT.CONTEXTS
CREATE VIEW SYSCAT.CONTEXTS AS create or replace view syscat.contexts 
(contextname , contextid, systemauthid, defaultcontextrole, 
create_time, alter_time, enabled, auditpolicyid, auditpolicyname, 
auditexceptionenabled, remarks) 
as select 
a.contextname , a.contextid, a.systemauthid,a.defaultcontextrole, 
a.create_time, a.alter_time, a.enabled, a.auditpolicyid, 
case when a.auditpolicyid is null then null 
else (select auditpolicyname from sysibm.sysauditpolicies aud 
where a.auditpolicyid = aud.auditpolicyid) 
end, 
a.auditexceptionenabled, b.remarks 
from sysibm.syscontexts a left outer join sysibm.syscomments b 
on a.contextid = b.objectid and b.objecttype = 'x'
;

-- View: SYSCAT.CONTROLDEP
CREATE VIEW SYSCAT.CONTROLDEP AS create or replace view syscat.controldep 
(dschema, dname, dtype, btype, bschema, bmodulename, bname, bmoduleid, 
bcolname ) 
as 
select 
a.dschema, a.dname, a.dtype, a.btype, a.bschema, m.modulename, a.bname, 
a.bmoduleid, cast(NULL as varchar(128)) 
from sysibm.sysdependencies a 
left outer join sysibm.sysmodules m on a.bmoduleid=m.moduleid 
where dtype = 'y' or dtype = '2' 
union all 
select 
b.dschema, 
b.dname, 
b.dtype, 
cast('C' as CHAR(1)), 
b.bschema, 
cast(NULL as varchar(128)), 
b.bname, 
cast(NULL as integer), 
b.bcolname 
from sysibm.syscoldependencies b 
where dtype = 'y' or dtype = '2' 

;

-- View: SYSCAT.CONTROLS
CREATE VIEW SYSCAT.CONTROLS AS create or replace view syscat.controls 
(controlschema, controlname, owner, ownertype, tabschema, tabname, colname, 
controlid, controltype, enforced, implicit, enable, valid, ruletext, 
tabcorrelation, qualifier, func_path, collationschema, 
collationname, collationschema_orderby, collationname_orderby, 
create_time, alter_time, envstringunits, remarks) 
as select 
a.controlschema, a.controlname, a.owner, a.ownertype, a.tabschema, a.tabname, 
a.colname, a.controlid, a.controltype, a.enforced, 
a.implicit, a.enable, a.valid, a.ruletext, a.tabcorrelation, a.qualifier, 
a.func_path, 
coalesce(c1.collationschema, 'SYSIBM'), 
coalesce(c1.collationname, syscat.collationname(a.collationid)), 
coalesce(c2.collationschema, 'SYSIBM'), 
coalesce(c2.collationname, syscat.collationname(a.collationid_orderby)), 
a.create_time, a.alter_time, 
cast(case 
when a.stringunits = 'S' then 'SYSTEM' 
when a.stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)), 
b.remarks 
from sysibm.syscontrols a 
left outer join sysibm.syscomments b 
on a.controlid = b.objectid and (b.objecttype = 'y' or 
b.objecttype = '2') 
left outer join sysibm.syscollations as c1 
on a.collationid = c1.collationid 
left outer join sysibm.syscollations as c2 
on a.collationid_orderby = c2.collationid 

;

-- View: SYSCAT.DATAPARTITIONEXPRESSION
CREATE VIEW SYSCAT.DATAPARTITIONEXPRESSION AS create or replace view syscat.datapartitionexpression 
(tabschema, tabname, datapartitionkeyseq, datapartitionexpression, 
nullsfirst) 
as select 
tabschema, tabname, datapartitionkeyseq, datapartitionexpression, 
nullsfirst 
from sysibm.sysdatapartitionexpression
;

-- View: SYSCAT.DATAPARTITIONS
CREATE VIEW SYSCAT.DATAPARTITIONS AS create or replace view syscat.datapartitions 
(datapartitionname, tabschema, tabname, datapartitionid, 
tbspaceid, partitionobjectid, long_tbspaceid, 
access_mode, status, seqno, 
lowinclusive, lowvalue, highinclusive, highvalue, 
card, overflow, npages, fpages, active_blocks, 
index_tbspaceid, avgrowsize, pctrowscompressed, 
pctpagesaved, avgcompressedrowsize, avgrowcompressionratio, 
stats_time, lastused, coldict_exists, 
coldict_create_time, coldict_alter_time) 
as select 
datapartitionname, tabschema, tabname, datapartitionid, 
tbspaceid, partitionobjectid, long_tbspaceid, 
access_mode, status, seqno, 
lowinclusive, lowvalue, highinclusive, highvalue, 
card, overflow, npages, fpages, active_blocks, 
index_tbspaceid, avgrowsize, pctrowscompressed, 
pctpagesaved, avgcompressedrowsize, avgrowcompressionratio, 
stats_time, lastused, coldict_exists, 
coldict_create_time, coldict_alter_time 
from sysibm.sysdatapartitions
;

-- View: SYSCAT.DATATYPEDEP
CREATE VIEW SYSCAT.DATATYPEDEP AS create or replace view syscat.datatypedep 
(typeschema, typemodulename, typename, typemoduleid, 
btype, bschema, bmodulename, bname, bmoduleid, tabauth) 
as select 
dschema, md.modulename, dname, dmoduleid, 
btype, bschema, mb.modulename, bname, bmoduleid, tabauth 
from 
sysibm.sysdependencies 
left outer join sysibm.sysmodules md on dmoduleid=md.moduleid 
left outer join sysibm.sysmodules mb on bmoduleid=mb.moduleid 
where dtype = 'R'
;

-- View: SYSCAT.DATATYPES
CREATE VIEW SYSCAT.DATATYPES AS create or replace view syscat.datatypes 
(typeschema, typemodulename, typename, owner, ownertype, 
sourceschema, sourcemodulename, sourcename, 
metatype, typerules, typeid, typemoduleid, sourcetypeid, sourcemoduleid, 
published, length, scale, typestringunits, stringunitslength, codepage, 
collationschema, collationname, 
array_length, arrayindextypeschema, arrayindextypename, arrayindextypeid, 
arrayindextypelength, arrayindextype_stringunits, 
arrayindextype_stringunitslength, create_time, valid, attrcount, 
instantiable, with_func_access, final, inline_length, natural_inline_length, 
jarschema, jar_id, class, sqlj_representation, 
alter_time, definer, nulls, func_path, constraint_text, last_regen_time, 
envstringunits, remarks) 
as select 
d.schema, m.modulename, d.name, d.definer, d.definertype, 
d.sourceschema, m2.modulename, d.sourcetype, 
case when d.metatype='W' then 'T' else d.metatype end, 
case when d.metatype='W' then 'W' 
when d.metatype='T' then 'S' 
else ' ' end, 
d.typeid, d.typemoduleid, d.sourcetypeid, d.sourcemoduleid, 
d.published, d.length, 
CASE WHEN (d.codepage=1208 or d.codepage=1200) and d.scale<>0 then CAST(0 as 
SMALLINT) 
ELSE d.scale END, 
CASE WHEN d.codepage=1208 and d.scale=0 THEN CAST('OCTETS' as VARCHAR(11)) 
WHEN d.codepage=1208 and d.scale=4 THEN CAST('CODEUNITS32' as VARCHAR(11)) 
WHEN d.codepage=1200 and d.scale=0 THEN CAST('CODEUNITS16' as VARCHAR(11)) 
WHEN d.codepage=1200 and d.scale=2 THEN CAST('CODEUNITS32' as VARCHAR(11)) 
ELSE CAST(NULL AS VARCHAR(11)) END, 
CASE WHEN (d.codepage=1208 or d.codepage=1200) and d.scale=0 THEN d.length 
WHEN (d.codepage=1208 or d.codepage=1200) and d.scale<>0 THEN 
CAST(d.length/d.scale as INTEGER) 
ELSE CAST(NULL AS INTEGER) END, 
d.codepage, 
case when d.collationid is null then null 
else coalesce(c.collationschema, 'SYSIBM') end, 
case when d.collationid is null then null 
else coalesce(c.collationname, syscat.collationname(d.collationid)) end, 
case when d.metatype='A' then d.array_length else null end, 
case when d.metatype='L' then cast('SYSIBM' as varchar(128)) else null end, 
case when d.metatype='L' then 
(select dd.name from sysibm.sysdatatypes dd 
where dd.typeid = d.arrayindextypeid) else null end, 
d.arrayindextypeid, 
case when d.metatype='L' then d.array_length else null end, 
CASE WHEN d.metatype='L' and d.arrayindextypeid=56 and 
(select ddcp.codepage from sysibm.sysdatatypes ddcp 
where ddcp.typeid=56)=1208 THEN 
CASE WHEN d.arrayindextypescale=0 THEN CAST('OCTETS' as VARCHAR(11)) 
WHEN d.arrayindextypescale=4 THEN 
CAST('CODEUNITS32' as VARCHAR(11)) 
ELSE CAST(NULL AS VARCHAR(11)) 
END 
ELSE CAST(NULL AS VARCHAR(11)) 
END, 
CASE WHEN d.metatype='L' and d.arrayindextypeid=56 and 
(select ddcp.codepage from sysibm.sysdatatypes ddcp 
where ddcp.typeid=56)=1208 THEN 
CASE WHEN d.arrayindextypescale=0 THEN d.array_length 
WHEN d.arrayindextypescale=4 THEN 
CAST(d.array_length/d.arrayindextypescale as INTEGER) 
ELSE CAST(NULL AS INTEGER) 
END 
ELSE CAST(NULL AS INTEGER) 
END, 
d.create_time, d.valid, d.attrcount, d.instantiable, 
d.with_func_access, d.final, d.inline_length, d.natural_inline_length, 
d.jarschema, d.jar_id, d.class, d.sqlj_representation, 
case when d.constraint_text is not null then d.create_time else d.alter_time 
end, 
d.definer, nulls, func_path, constraint_text, d.alter_time, 
cast(case 
when d.stringunits = 'S' then 'SYSTEM' 
when d.stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)), 
d.remarks 
from sysibm.sysdatatypes as d left outer join sysibm.syscollations as c 
on d.collationid = c.collationid 
left outer join sysibm.sysmodules m on d.typemoduleid=m.moduleid 
left outer join sysibm.sysmodules m2 on d.sourcemoduleid = m2.moduleid
;

-- View: SYSCAT.DBAUTH
CREATE VIEW SYSCAT.DBAUTH AS create or replace view syscat.dbauth 
(grantor, grantortype, grantee, granteetype, 
bindaddauth, connectauth, createtabauth, dbadmauth, 
externalroutineauth, implschemaauth, loadauth, 
nofenceauth, quiesceconnectauth, libraryadmauth, securityadmauth, 
sqladmauth, wlmadmauth, explainauth, dataaccessauth, accessctrlauth, 
createsecureauth) 
as select 
grantor, grantortype, grantee, granteetype, 
bindaddauth, connectauth, createtabauth, dbadmauth, 
externalroutineauth, implschemaauth, loadauth, 
nofenceauth, quiesceconnectauth, libraryadmauth, securityadmauth, 
sqladmauth, wlmadmauth, explainauth, dataaccessauth, accessctrlauth, 
createsecureauth 
from sysibm.sysdbauth
;

-- View: SYSCAT.DBPARTITIONGROUPDEF
CREATE VIEW SYSCAT.DBPARTITIONGROUPDEF AS create or replace view syscat.dbpartitiongroupdef 
(dbpgname, dbpartitionnum, in_use) 
as select 
ngname, nodenum, in_use 
from sysibm.sysnodegroupdef
;

-- View: SYSCAT.DBPARTITIONGROUPS
CREATE VIEW SYSCAT.DBPARTITIONGROUPS AS create or replace view syscat.dbpartitiongroups 
(dbpgname, owner, ownertype, pmap_id, redistribute_pmap_id, create_time, 
definer, remarks) 
as select 
name, definer, definertype, pmap_id, rebalance_pmap_id, ctime, 
definer, remarks 
from sysibm.sysnodegroups
;

-- View: SYSCAT.EVENTMONITORS
CREATE VIEW SYSCAT.EVENTMONITORS AS create or replace view syscat.eventmonitors 
(evmonname, owner, ownertype, target_type, target, maxfiles, 
maxfilesize, buffersize, io_mode, write_mode, autostart, 
dbpartitionnum, monscope, evmon_activates, nodenum, 
definer, versionnumber, member, remarks) 
as select 
name, definer, definertype, target_type, target, maxfiles, 
maxfilesize, buffersize, io_mode, write_mode, autostart, 
nodenum, monscope, evmon_activates, nodenum, 
definer, versionnumber, nodenum, remarks 
from sysibm.syseventmonitors
;

-- View: SYSCAT.EVENTS
CREATE VIEW SYSCAT.EVENTS AS create or replace view syscat.events 
(evmonname, type, filter) 
as select 
name, type, filter 
from sysibm.sysevents
;

-- View: SYSCAT.EVENTTABLES
CREATE VIEW SYSCAT.EVENTTABLES AS create or replace view syscat.eventtables 
(evmonname, logical_group, tabschema, tabname, pctdeactivate, taboptions) 
as select 
evmonname, logical_group, tabschema, tabname, pctdeactivate, taboptions 
from sysibm.syseventtables
;

-- View: SYSCAT.EXTERNALTABLEOPTIONS
CREATE VIEW SYSCAT.EXTERNALTABLEOPTIONS AS CREATE OR REPLACE VIEW SYSCAT.EXTERNALTABLEOPTIONS 
( TABLENAME, FILENAME, 
FIELDDELIMITER, RECORDDELIMITER, DECIMALDELIMITER, DATEDELIMITER, 
TIMEDELIMITER, DATESTYLE, TIMESTYLE, BOOLEANSTYLE, 
NULLVALUE, QUOTEDVALUE, 
REQUIREQUOTES, RECORDLENGTH, MAXERRORS, MAXROWS, Y2BASE, FORMAT, ENCODING, 
REMOTESOURCE, SOCKETBUFFERSIZE, SKIPROWS, 
ISFILLRECORD, ISESCAPE, ISCRINSTRING, ISTRUNCSTRING, ISCONTROLCHARACTERS, 
ISIGNOREZERO, ISTIMEROUNDNANOS, ISCOMPRESS, ISINCLUDEHEADER, 
ISINCLUDEZEROSECONDS, 
LOGFILEPATH) 
AS SELECT 
T.NAME, F.DATAFILE, E.FIELDDELIM, E.RECDELIM, E.DECIMALDELIM, E.DATEDELIM, 
E.TIMEDELIM, 
E.DATESTYLE, 
CASE 
WHEN E.TIMESTYLE = 'Q'       THEN '24HOUR' 
WHEN E.TIMESTYLE = 'R'       THEN '12HOUR' 
ELSE E.TIMESTYLE 
END, 
E.BOOLSTYLE, 
E.NULLVALUE, 
E.QUOTEDVALUE, 
CASE 
WHEN E.REQUIREQUOTES = 'N'   THEN 'FALSE' 
WHEN E.REQUIREQUOTES = 'Y'   THEN 'TRUE' 
ELSE E.REQUIREQUOTES 
END, 
E.RECORDLENGTH, 
E.MAXERRORS, 
E.MAXROWS, 
E.Y2BASE, 
CASE 
WHEN E.FORMAT ='0'         THEN 'TEXT' 
WHEN E.FORMAT ='1'         THEN 'INTERNAL' 
WHEN E.FORMAT ='2'         THEN 'FIXED' 
WHEN E.FORMAT ='3'         THEN 'BINARY' 
WHEN E.FORMAT ='4'         THEN 'GENERIC' 
WHEN E.FORMAT ='5'         THEN 'NZ_REPL' 
WHEN E.FORMAT ='6'         THEN 'DB2Z_BRF' 
WHEN E.FORMAT ='7'         THEN 'DB2Z_RRF' 
ELSE E.FORMAT 
END, 
E.ENCODING, 
CASE 
WHEN E.REMOTESOURCE = '0'    THEN 'LOCAL' 
WHEN E.REMOTESOURCE = '1'    THEN 'ODBC' 
WHEN E.REMOTESOURCE = '2'    THEN 'JDBC' 
WHEN E.REMOTESOURCE = '3'    THEN 'OLEDB' 
WHEN E.REMOTESOURCE = '4'    THEN 'NZ_REPLSRV' 
ELSE E.REMOTESOURCE 
END, 
E.SOCKETBUFSIZE, 
E.SKIPROWS, 
CASE 
WHEN E.ISFILLRECORD = 'N'   THEN 'FALSE' 
WHEN E.ISFILLRECORD = 'Y'   THEN 'TRUE' 
ELSE E.ISFILLRECORD 
END, 
E.ISESCAPE, 
CASE 
WHEN E.ISCRINSTRING = 'N'   THEN 'FALSE' 
WHEN E.ISCRINSTRING = 'Y'   THEN 'TRUE' 
ELSE E.ISCRINSTRING 
END, 
CASE 
WHEN E.ISTRUNCSTRING = 'N'  THEN 'FALSE' 
WHEN E.ISTRUNCSTRING = 'Y'  THEN 'TRUE' 
ELSE E.ISTRUNCSTRING 
END, 
CASE 
WHEN E.ISCTRLCHARS = 'N'    THEN 'FALSE' 
WHEN E.ISCTRLCHARS = 'Y'    THEN 'TRUE' 
ELSE E.ISCTRLCHARS 
END, 
CASE 
WHEN E.ISIGNOREZERO = 'N'   THEN 'FALSE' 
WHEN E.ISIGNOREZERO = 'Y'   THEN 'TRUE' 
ELSE E.ISIGNOREZERO 
END, 
CASE 
WHEN E.ISTIMEROUNDNANOS = 'N'    THEN 'FALSE' 
WHEN E.ISTIMEROUNDNANOS = 'Y'    THEN 'TRUE' 
ELSE E.ISTIMEROUNDNANOS 
END, 
CASE 
WHEN E.ISCOMPRESS = 'N'          THEN 'FALSE' 
WHEN E.ISCOMPRESS = 'Y'          THEN 'TRUE' 
ELSE E.ISCOMPRESS 
END, 
CASE 
WHEN E.ISINCLUDEHEADER = 'N'     THEN 'FALSE' 
WHEN E.ISINCLUDEHEADER = 'Y'     THEN 'TRUE' 
ELSE E.ISINCLUDEHEADER 
END, 
CASE 
WHEN E.ISINCLUDEZEROSECONDS = 'N'       THEN 'FALSE' 
WHEN E.ISINCLUDEZEROSECONDS = 'Y'       THEN 'TRUE' 
ELSE E.ISINCLUDEZEROSECONDS 
END, 
E.LOGPATH 
FROM 
SYSIBM.SYSTABLES        T, 
SYSIBM.SYSEXTTAB        E, 
SYSIBM.SYSEXTTABFILEOBJ F 
WHERE 
E.ETID=T.FID and 
F.ETID = T.FID and 
E.ETID = F.ETID 

;

-- View: SYSCAT.FULLHIERARCHIES
CREATE VIEW SYSCAT.FULLHIERARCHIES AS create or replace view syscat.fullhierarchies 
(metatype, sub_schema, sub_name, 
super_schema, super_name, 
root_schema, root_name) 
as 
(select metatype, sub_schema, sub_name, 
super_schema, super_name, 
root_schema, root_name 
from sysibm.syshierarchies) 
union all 
(select h.metatype, h.sub_schema, h.sub_name, 
f.super_schema, f.super_name, 
h.root_schema, h.root_name 
from syscat.fullhierarchies as f, 
sysibm.syshierarchies as h 
where f.sub_schema = h.super_schema 
and f.sub_name = h.super_name)
;

-- View: SYSCAT.FUNCDEP
CREATE VIEW SYSCAT.FUNCDEP AS create or replace view syscat.funcdep 
(funcschema, funcmodulename, funcname, funcmoduleid, btype, bschema, 
bmodulename, bname, bmoduleid, tabauth) 
as select 
dschema, md.modulename, dname, dmoduleid, btype, bschema, 
mb.modulename, bname, bmoduleid, tabauth 
from sysibm.sysdependencies 
left outer join sysibm.sysmodules md on dmoduleid=md.moduleid 
left outer join sysibm.sysmodules mb on bmoduleid=mb.moduleid 
where dtype = 'F'
;

-- View: SYSCAT.FUNCMAPOPTIONS
CREATE VIEW SYSCAT.FUNCMAPOPTIONS AS create or replace view syscat.funcmapoptions 
(function_mapping, option, setting) 
as select 
function_mapping, option, setting 
from sysibm.sysfuncmapoptions
;

-- View: SYSCAT.FUNCMAPPARMOPTIONS
CREATE VIEW SYSCAT.FUNCMAPPARMOPTIONS AS create or replace view syscat.funcmapparmoptions 
(function_mapping, ordinal, location, option, setting) 
as select 
function_mapping, ordinal, location, option, setting 
from sysibm.sysfuncmapparmoptions
;

-- View: SYSCAT.FUNCMAPPINGS
CREATE VIEW SYSCAT.FUNCMAPPINGS AS create or replace view syscat.funcmappings 
(function_mapping, funcschema, funcname, funcid, 
specificname, owner, ownertype, wrapname, servername, servertype, 
serverversion, create_time, definer, remarks) 
as select 
function_mapping, funcschema, funcname, funcid, 
specificname, definer, definertype, wrapname, servername, servertype, 
serverversion, create_time, definer, remarks 
from sysibm.sysfuncmappings
;

-- View: SYSCAT.FUNCPARMS
CREATE VIEW SYSCAT.FUNCPARMS AS create or replace view syscat.funcparms 
(funcschema, funcname, specificname, rowtype, ordinal, 
parmname, typeschema, typename, length, scale, codepage, 
cast_funcid, as_locator, target_typeschema, 
target_typename, scope_tabschema, scope_tabname, 
transform_grpname) 
as select 
routineschema, routinename, specificname, rowtype, ordinal, 
parmname, typeschema, typename, length, scale, codepage, 
cast_function_id, locator, target_typeschema, 
target_typename, scope_tabschema, scope_tabname, 
transform_grpname 
from sysibm.sysroutineparms 
where routinetype in ('F', 'M') 
and routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSCAT.FUNCTIONS
CREATE VIEW SYSCAT.FUNCTIONS AS create or replace view syscat.functions 
(funcschema, funcname, specificname, definer, funcid, 
return_type, origin, type, method, effect, parm_count, 
parm_signature, create_time, qualifier, with_func_access, 
type_preserving, variant, side_effects, fenced, nullcall, 
cast_function, assign_function, scratchpad, 
final_call, parallelizable, contains_sql, dbinfo, result_cols, 
language, implementation, class, jar_id, 
parm_style, source_schema, source_specific, ios_per_invoc, 
insts_per_invoc, ios_per_argbyte, insts_per_argbyte, 
percent_argbytes, initial_ios, initial_insts, cardinality, 
implemented, selectivity, overridden_funcid, 
subject_typeschema, subject_typename, func_path, body, 
remarks) 
as select 
a.routineschema, a.routinename, a.specificname, a.definer, a.routine_id, 
a.return_type, a.origin, a.function_type, 
CAST (CASE a.routinetype 
WHEN 'M' THEN 'Y' 
ELSE 'N' END AS CHAR(1)), 
a.methodeffect, a.parm_count, 
a.parm_signature, a.createdts, a.qualifier, a.with_func_access, 
CAST (CASE 
WHEN a.type_preserving = 'Y' 
THEN 'Y' 
ELSE 'N' 
END AS CHAR(1)), 
CAST (CASE a.deterministic 
WHEN 'Y' THEN 'N' 
WHEN 'N' THEN 'Y' 
ELSE ' ' END AS CHAR(1)), 
a.external_action, a.fenced, a.null_call, 
a.cast_function, a.assign_function, a.scratchpad, 
a.final_call, a.parallel, a.sql_data_access, a.dbinfo, a.result_cols, 
a.language, a.implementation, 
(SELECT pj.class FROM 
SYSIBM.SYSROUTINEPROPERTIES AS pj 
WHERE pj.routine_id = a.routine_id), 
(SELECT pj.jar_id FROM 
SYSIBM.SYSROUTINEPROPERTIES AS pj 
WHERE pj.routine_id = a.routine_id), 
a.parameter_style, a.sourceschema, a.sourcespecific, a.ios_per_invoc, 
a.insts_per_invoc, a.ios_per_argbyte, a.insts_per_argbyte, 
a.percent_argbytes, a.initial_ios, a.initial_insts, a.cardinality, 
a.methodimplemented, a.selectivity, a.overridden_methodid, 
a.subject_typeschema, a.subject_typename, a.func_path, a.text, 
a.remarks 
from sysibm.sysroutines as a 
where a.routinetype in ('F', 'M') 
and a.routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSCAT.HIERARCHIES
CREATE VIEW SYSCAT.HIERARCHIES AS create or replace view syscat.hierarchies 
(metatype, sub_schema, sub_name, super_schema, 
super_name, root_schema, root_name) 
as select 
metatype, sub_schema, sub_name, super_schema, 
super_name, root_schema, root_name 
from sysibm.syshierarchies
;

-- View: SYSCAT.HISTOGRAMTEMPLATEBINS
CREATE VIEW SYSCAT.HISTOGRAMTEMPLATEBINS AS create or replace view syscat.histogramtemplatebins 
(templatename, templateid, binid, binuppervalue) 
as select 
a.templatename, b.templateid, b.binid, b.binuppervalue 
from sysibm.syshistogramtemplatebins as b left outer join 
sysibm.syshistogramtemplates as a 
on b.templateid = a.templateid
;

-- View: SYSCAT.HISTOGRAMTEMPLATES
CREATE VIEW SYSCAT.HISTOGRAMTEMPLATES AS create or replace view syscat.histogramtemplates 
(templateid, templatename, create_time, alter_time, 
numbins, remarks) 
as select 
a.templateid, a.templatename, a.create_time, a.alter_time, 
a.numbins, b.remarks 
from sysibm.syshistogramtemplates as a left outer join 
sysibm.syscomments as b 
on b.objectid = a.templateid and b.objecttype = 'h'
;

-- View: SYSCAT.HISTOGRAMTEMPLATEUSE
CREATE VIEW SYSCAT.HISTOGRAMTEMPLATEUSE AS create or replace view syscat.histogramtemplateuse 
(templatename, templateid, histogramtype, 
objecttype, objectid, serviceclassname, parentserviceclassname, 
workactionname, workactionsetname, workloadname) 
as select 
a.templatename, b.templateid, b.histogramtype, 
b.objecttype, b.objectid, 
case when b.objecttype in 'b' then 
c.serviceclassname 
else 
cast(null as varchar(128)) end, 
case when b.objecttype in 'b' then 
d.serviceclassname 
else 
cast(null as varchar(128)) end, 
case when b.objecttype in 'k' then 
e.actionname 
else 
cast(null as varchar(128)) end, 
case when b.objecttype in 'k' then 
f.actionsetname 
else 
cast(null as varchar(128)) end, 
case when b.objecttype in 'w' then 
g.workloadname 
else 
cast(null as varchar(128)) end 
from sysibm.syshistogramtemplateuse as b 
left outer join sysibm.syshistogramtemplates as a 
on b.templateid = a.templateid 
left outer join sysibm.sysserviceclasses as c 
on c.serviceclassid = b.objectid 
left outer join sysibm.sysserviceclasses as d 
on c.parentid = d.serviceclassid 
left outer join sysibm.sysworkactions as e 
on e.actionid = b.objectid 
left outer join sysibm.sysworkactionsets as f 
on e.actionsetid = f.actionsetid 
left outer join sysibm.sysworkloads as g 
on g.workloadid = b.objectid 
;

-- View: SYSCAT.INDEXAUTH
CREATE VIEW SYSCAT.INDEXAUTH AS create or replace view syscat.indexauth 
(grantor, grantortype, grantee, granteetype, indschema, indname, 
controlauth) 
as select 
grantor, grantortype, grantee, granteetype, creator, name, 
controlauth 
from sysibm.sysindexauth
;

-- View: SYSCAT.INDEXCOLUSE
CREATE VIEW SYSCAT.INDEXCOLUSE AS create or replace view syscat.indexcoluse 
(indschema, indname, colname, colseq, colorder, collationschema, 
collationname, virtual, text) 
as select 
indschema, indname, colname, colseq, 
case when i.colorder <> 'V' THEN  i.colorder else cast ('A' as char(1)) end, 
case when i.collationid is null then null 
else coalesce(c.collationschema, 'SYSIBM') end, 
case when i.collationid is null then null 
else coalesce(c.collationname, syscat.collationname(i.collationid)) end, 
cast (case when i.colorder = 'V' then 'Y' 
when i.text is not null then 'S' 
else 'N' end as char(1)), 
text 
from sysibm.sysindexcoluse as i left outer join sysibm.syscollations as c 
on i.collationid = c.collationid
;

-- View: SYSCAT.INDEXDEP
CREATE VIEW SYSCAT.INDEXDEP AS create or replace view syscat.indexdep 
(indschema, indname, btype, bschema, bmodulename, bname, bmoduleid, tabauth) 
as select 
dschema, dname, btype, bschema, m.modulename, bname, bmoduleid, tabauth 
from sysibm.sysdependencies 
left outer join sysibm.sysmodules m on bmoduleid=m.moduleid 
where dtype = 'I'
;

-- View: SYSCAT.INDEXES
CREATE VIEW SYSCAT.INDEXES AS create or replace view syscat.indexes 
(indschema, indname, owner, ownertype, tabschema, tabname, colnames, 
uniquerule, made_unique, colcount, 
unique_colcount, indextype, entrytype, pctfree, 
iid, nleaf, nlevels, 
firstkeycard, first2keycard, first3keycard, first4keycard, 
fullkeycard, clusterratio, clusterfactor, sequential_pages, 
density, user_defined, system_required, create_time, 
stats_time, page_fetch_pairs, minpctused, reverse_scans, 
internal_format, compression, 
ieschema, iename, iearguments, index_objectid, 
numrids, numrids_deleted, num_empty_leafs, 
average_random_fetch_pages, average_random_pages, 
average_sequence_gap, average_sequence_fetch_gap, 
average_sequence_pages, average_sequence_fetch_pages, 
tbspaceid, level2pctfree, pagesplit, 
avgpartition_clusterratio, avgpartition_clusterfactor, 
avgpartition_page_fetch_pairs, pctpagessaved, 
datapartition_clusterfactor, indcard, avgleafkeysize, 
avgnleafkeysize, os_ptr_size, 
collectstatistcs, definer, lastused, 
periodname, periodpolicy, made_withoutoverlaps, 
envstringunits, nullkeys, func_path, viewschema, viewname, remarks) 
as select 
creator, name, definer, definertype, tbcreator, tbname, 
coalesce(sysibm.deprecatedchar('-206', 'COLUMN', 
'SYSCAT.INDEXES.COLNAMES'), 
colnames), 
uniquerule, made_unique, colcount, 
unique_colcount,indextype, entrytype, pctfree, 
iid, nleaf, nlevels, 
firstkeycard, first2keycard, first3keycard, first4keycard, 
fullkeycard, clusterratio, clusterfactor, sequential_pages, 
density, user_defined, system_required, create_time, 
stats_time, page_fetch_pairs, minpctused, reverse_scans, 
internal_format, compression, 
ieschema, iename, iearguments, index_objectid, 
numrids, numrids_deleted, num_empty_leafs, 
average_random_fetch_pages, average_random_pages, 
average_sequence_gap, average_sequence_fetch_gap, 
average_sequence_pages, average_sequence_fetch_pages, 
tbspaceid, level2pctfree, pagesplit, 
avgpartition_clusterratio, avgpartition_clusterfactor, 
avgpartition_page_fetch_pairs, pctpagessaved, 
datapartition_clusterfactor, indcard, avgleafkeysize, 
avgnleafkeysize, os_ptr_size, 
collectstatistics, definer, lastused, 
periodname, periodpolicy, made_withoutoverlaps, 
cast(case 
when stringunits = 'S' then 'SYSTEM' 
when stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)), 
nullkeys, func_path, 
(select d.bschema 
from sysibm.sysdependencies d, 
sysibm.systables t 
where i.func_path is not null and 
d.btype = 'V' and 
d.bname = t.name and 
d.bschema = t.creator and 
d.dtype = 'I' and 
d.dname = i.name and 
d.dschema = i.creator and 
substr(t.property, 19, 1) = 'Y' 
), 
(select d.bname 
from sysibm.sysdependencies d, 
sysibm.systables t 
where i.func_path is not null and 
d.btype = 'V' and 
d.bname = t.name and 
d.bschema = t.creator and 
d.dtype = 'I' and 
d.dname = i.name and 
d.dschema = i.creator and 
substr(t.property, 19, 1) = 'Y'), 
remarks 
from sysibm.sysindexes i 

;

-- View: SYSCAT.INDEXEXPLOITRULES
CREATE VIEW SYSCAT.INDEXEXPLOITRULES AS create or replace view syscat.indexexploitrules 
(funcid, specid, ieschema, iename, ruleid, searchmethodid, 
searchkey, searchargument, exact) 
as select 
funcid, specid, ieschema, iename, ruleid, searchmethodid, 
searchkey, searchargument, exact 
from sysibm.sysindexexploitrules
;

-- View: SYSCAT.INDEXEXTENSIONDEP
CREATE VIEW SYSCAT.INDEXEXTENSIONDEP AS create or replace view syscat.indexextensiondep 
(ieschema, iename, btype, bschema, bmodulename, bname, bmoduleid, tabauth) 
as select 
dschema, dname, btype, bschema, m.modulename, bname, bmoduleid, tabauth 
from sysibm.sysdependencies 
left outer join sysibm.sysmodules m on bmoduleid=m.moduleid 
where dtype = 'X'
;

-- View: SYSCAT.INDEXEXTENSIONMETHODS
CREATE VIEW SYSCAT.INDEXEXTENSIONMETHODS AS create or replace view syscat.indexextensionmethods 
(methodname, methodid, ieschema, iename, rangefuncschema, 
rangefuncname, rangespecificname, filterfuncschema, 
filterfuncname, filterspecificname, remarks) 
as select 
methodname, methodid, ieschema, iename, rtfuncschema, 
rtfuncname, rtspecificname, cwfuncschema, cwfuncname, 
cwspecificname, remarks 
from sysibm.sysindexextensionmethods
;

-- View: SYSCAT.INDEXEXTENSIONPARMS
CREATE VIEW SYSCAT.INDEXEXTENSIONPARMS AS create or replace view syscat.indexextensionparms 
(ieschema, iename, ordinal, parmname, typeschema, typename, 
length, scale, parmtype, codepage, collationschema, collationname) 
as select 
i.ieschema, i.iename, i.ordinal, i.parmname, i.typeschema, i.typename, 
i.length, i.scale, i.parmtype, i.codepage, 
case when i.collationid is null then null 
else coalesce(c.collationschema, 'SYSIBM') end, 
case when i.collationid is null then null 
else coalesce(c.collationname, syscat.collationname(i.collationid)) end 
from sysibm.sysindexextensionparms as i 
left outer join sysibm.syscollations as c on i.collationid = c.collationid
;

-- View: SYSCAT.INDEXEXTENSIONS
CREATE VIEW SYSCAT.INDEXEXTENSIONS AS create or replace view syscat.indexextensions 
(ieschema, iename, owner, ownertype, create_time, keygenfuncschema, 
keygenfuncname, keygenspecificname, text, definer, remarks) 
as select 
ieschema, iename, definer, definertype, create_time, ktfuncschema, 
ktfuncname, ktspecificname, text, definer, remarks 
from sysibm.sysindexextensions
;

-- View: SYSCAT.INDEXOPTIONS
CREATE VIEW SYSCAT.INDEXOPTIONS AS create or replace view syscat.indexoptions 
(indschema, indname, option, setting) 
as select 
indschema, indname, option, setting 
from sysibm.sysindexoptions
;

-- View: SYSCAT.INDEXPARTITIONS
CREATE VIEW SYSCAT.INDEXPARTITIONS AS create or replace view syscat.indexpartitions 
(indschema, indname, tabschema, tabname, iid, 
indpartitiontbspaceid, indpartitionobjectid, 
datapartitionid, indcard, nleaf, 
num_empty_leafs, numrids, numrids_deleted, 
fullkeycard, nlevels, clusterratio, clusterfactor, 
firstkeycard, first2keycard, first3keycard, 
first4keycard, avgleafkeysize, avgnleafkeysize, 
pctfree, page_fetch_pairs, sequential_pages, 
density, average_sequence_gap, average_sequence_fetch_gap, 
average_sequence_pages, average_sequence_fetch_pages, 
average_random_pages, average_random_fetch_pages, stats_time, 
compression, pctpagessaved) 
as select 
indschema, indname, tabschema, tabname, iid, 
indpartitiontbspaceid, indpartitionobjectid, 
datapartitionid, indcard, nleaf, 
num_empty_leafs, numrids, numrids_deleted, 
fullkeycard, nlevels, clusterratio, clusterfactor, 
firstkeycard, first2keycard, first3keycard, 
first4keycard, avgleafkeysize, avgnleafkeysize, 
pctfree, page_fetch_pairs, sequential_pages, 
density, average_sequence_gap, average_sequence_fetch_gap, 
average_sequence_pages, average_sequence_fetch_pages, 
average_random_pages, average_random_fetch_pages, stats_time, 
compression, pctpagessaved 
from sysibm.sysindexpartitions 
;

-- View: SYSCAT.INDEXXMLPATTERNS
CREATE VIEW SYSCAT.INDEXXMLPATTERNS AS create or replace view syscat.indexxmlpatterns 
(indschema, indname, pindname, pindid, typemodel, datatype, hashed, length, 
scale, patternid, pattern) 
as select 
indschema, indname, pindname, pindid, typemodel, datatype, hashed, length, 
scale, patternid, pattern 
from sysibm.sysindexxmlpatterns
;

-- View: SYSCAT.INVALIDOBJECTS
CREATE VIEW SYSCAT.INVALIDOBJECTS AS create or replace view syscat.invalidobjects 
(objectschema, objectmodulename, objectname, routinename, objecttype, 
sqlcode, sqlstate, errormessage, linenumber, 
invalidate_time, last_regen_time) 
as select 
i.objectschema, m.modulename, i.objectname, 
case when i.objecttype = 'F' then r.routinename else null end, 
i.objecttype, i.sqlcode, i.sqlstate, 
cast(case when i.sqlcode is not null then 
case when i.sqlcode < 0 
then substring(SYSPROC.SQLERRM (concat('SQL', 
substring(varchar(i.sqlcode), 
2, octets)), i.sqlerrmc, x'FF', '', 1), 1, 4000, octets) 
else substring(SYSPROC.SQLERRM (concat('SQL', varchar(i.sqlcode)), 
i.sqlerrmc, 
x'FF', '', 1), 1, 4000, octets) end 
else null end as varchar(4000)), 
i.linenumber, i.invalidate_time, i.last_regen_time 
from sysibm.sysinvalidobjects i 
left outer join sysibm.sysroutines r on (i.objectname = r.specificname and 
i.objectschema = r.routineschema and (i.objectmoduleid = r.routinemoduleid or 
(i.objectmoduleid is NULL and r.routinemoduleid is NULL))) 
left outer join sysibm.sysmodules m on i.objectmoduleid = m.moduleid 

;

-- View: SYSCAT.KEYCOLUSE
CREATE VIEW SYSCAT.KEYCOLUSE AS create or replace view syscat.keycoluse 
(constname, tabschema, tabname, colname, colseq) 
as select 
constname, tbcreator, tbname, colname, colseq 
from sysibm.syskeycoluse
;

-- View: SYSCAT.LIBRARIES
CREATE VIEW SYSCAT.LIBRARIES AS create or replace view syscat.libraries 
(libschema, libname, owner, ownertype, lib_id, libversion_count, 
active_version, system_required, definer) 
as select 
libschema, libname, definer, definertype, lib_id, libversion_count, 
active_version, system_required, definer 
from sysibm.syslibraries 
;

-- View: SYSCAT.LIBRARYAUTH
CREATE VIEW SYSCAT.LIBRARYAUTH AS create or replace view syscat.libraryauth 
(grantor, grantortype, grantee, granteetype, libschema, libname, 
alterauth, usageauth) 
as select 
grantor, grantortype, grantee, granteetype, libschema, libname, 
alterauth, usageauth 
from sysibm.syslibraryauth
;

-- View: SYSCAT.LIBRARYBINDFILES
CREATE VIEW SYSCAT.LIBRARYBINDFILES AS create or replace view syscat.librarybindfiles 
(libschema, libname, libversion, package_schema, 
package_name, package_version, bindfile_path) 
as select 
l.libschema, l.libname, b.libversion, b.package_schema, 
b.package_name, b.package_version, 
b.bindfile_path 
from sysibm.syslibrarybindfiles as b, 
sysibm.syslibraries as l 
where b.lib_id = l.lib_id
;

-- View: SYSCAT.LIBRARYVERSIONS
CREATE VIEW SYSCAT.LIBRARYVERSIONS AS create or replace view syscat.libraryversions 
(libschema, libname, libversion, owner, ownertype, versionid, 
create_time, version_path, bindfiles_count, definer ) 
as select 
l.libschema, l.libname, v.libversion, v.definer, v.definertype, 
cast('L' || digits (v.lib_id) || 'V' || digits (v.libversion) as varchar(22)), 
v.create_time, v.version_path, v.bindfiles_count, v.definer 
from sysibm.syslibraryversions as v, 
sysibm.syslibraries as l 
where v.lib_id = l.lib_id
;

-- View: SYSCAT.MEMBERSUBSETATTRS
CREATE VIEW SYSCAT.MEMBERSUBSETATTRS AS create or replace view syscat.membersubsetattrs 
(subsetid, attrid, attrvalue) 
as select 
a.subsetid, a.attrid, a.attrvalue 
from sysibm.sysmembersubsetattrs as a 
;

-- View: SYSCAT.MEMBERSUBSETMEMBERS
CREATE VIEW SYSCAT.MEMBERSUBSETMEMBERS AS create or replace view syscat.membersubsetmembers 
(subsetid, member, failover_priority) 
as select 
m.subsetid, m.member, m.failover_priority 
from sysibm.sysmembersubsetmembers as m 
;

-- View: SYSCAT.MEMBERSUBSETS
CREATE VIEW SYSCAT.MEMBERSUBSETS AS create or replace view syscat.membersubsets 
(subsetname, subsetid, create_time, alter_time, enabled, 
memberprioritybasis, inclusivesubset, alternateserver, 
catalogdatabasealias, remarks) 
as select 
m.subsetname, m.subsetid, m.create_time, m.alter_time, m.enabled, 
m.memberprioritybasis, m.inclusivesubset, m.alternateserver, 
m.catalogdatabasealias, m.remarks 
from sysibm.sysmembersubsets as m 
;

-- View: SYSCAT.MODULEAUTH
CREATE VIEW SYSCAT.MODULEAUTH AS create or replace view syscat.moduleauth 
(grantor, grantortype, grantee, granteetype, moduleid, 
moduleschema, modulename, executeauth) 
as select 
a.grantor, a.grantortype, a.grantee, a.granteetype, a.moduleid, 
m.moduleschema, m.modulename, a.executeauth 
from sysibm.sysmoduleauth a, sysibm.sysmodules m 
where a.moduleid = m.moduleid and 
not (a.grantee LIKE 'SYSROLE%' and a.granteetype='R')
;

-- View: SYSCAT.MODULEOBJECTS
CREATE VIEW SYSCAT.MODULEOBJECTS AS create or replace view syscat.moduleobjects 
(objectschema, objectmodulename, objectname, 
objecttype, published, specificname, userdefined) 
as 
SELECT r.routineschema, m.modulename, r.routinename, 
cast(case r.routinetype 
when 'P' then 'PROCEDURE' 
when 'M' then 'METHOD' 
else 'FUNCTION' 
end as varchar(9)), 
r.published, r.specificname, 
cast (case r.origin 
when 'S' then 'N' 
when 'T' then 'N' 
else 'Y' 
end as char(1)) 
FROM sysibm.sysroutines as r, sysibm.sysmodules as m 
WHERE r.routinemoduleid = m.moduleid 
UNION ALL 
SELECT v.varschema, m.modulename, v.varname, 
cast('CONDITION' as varchar(9)), 
v.published, NULL, cast('Y' as char(1)) 
FROM sysibm.sysvariables as v, sysibm.sysdatatypes as d, sysibm.sysmodules 
as m 
WHERE v.typeid = d.typeid 
AND v.varmoduleid = m.moduleid 
AND d.schema = 'SYSPROC' and d.name = 'DB2SQLSTATE' 
UNION ALL 
SELECT v.varschema, m.modulename, v.varname, 
cast('VARIABLE' as varchar(9)), 
v.published, NULL, cast('Y' as char(1)) 
FROM sysibm.sysvariables as v,  sysibm.sysdatatypes as d, sysibm.sysmodules 
as m 
WHERE v.typeid = d.typeid 
AND v.varmoduleid = m.moduleid 
AND not(d.schema = 'SYSPROC' and d.name = 'DB2SQLSTATE') 
UNION ALL 
SELECT t.schema, m.modulename, t.name, 
cast('TYPE' as varchar(9)), 
t.published, NULL, cast('Y' as char(1)) 
FROM sysibm.sysdatatypes as t, sysibm.sysmodules as m 
WHERE t.typemoduleid = m.moduleid 

;

-- View: SYSCAT.MODULES
CREATE VIEW SYSCAT.MODULES AS create or replace view syscat.modules 
(moduleschema, modulename, moduleid, dialect, owner, ownertype, moduletype, 
base_moduleschema, base_modulename, create_time, remarks) 
as select 
moduleschema, modulename, moduleid, 
CAST (CASE 
WHEN moduletype = 'P' THEN 'PL/SQL' 
WHEN moduletype = 'A' THEN ' ' 
ELSE 'DB2 SQL PL' 
END AS VARCHAR(10)), 
owner, ownertype, moduletype, base_moduleschema, base_modulename, create_time, 
r.remarks 
from 
sysibm.sysmodules left outer join sysibm.syscomments r 
on moduleid = r.objectid and r.objecttype = 'm'
;

-- View: SYSCAT.NAMEMAPPINGS
CREATE VIEW SYSCAT.NAMEMAPPINGS AS create or replace view syscat.namemappings 
(type, logical_schema, logical_name, logical_colname, 
impl_schema, impl_name, impl_colname) 
as select 
type, logical_schema, logical_name, logical_colname, 
impl_schema, impl_name, impl_colname 
from sysibm.sysnamemappings
;

-- View: SYSCAT.NICKNAMES
CREATE VIEW SYSCAT.NICKNAMES AS create or replace view syscat.nicknames 
(tabschema, tabname, owner, ownertype, status, 
create_time, stats_time, colcount, tableid, 
tbspaceid, card, npages, fpages, overflow, 
parents, children, selfrefs, 
keycolumns, keyindexid, keyunique, checkcount, 
datacapture, const_checked,  partition_mode, 
statistics_profile, 
access_mode, 
codepage , 
remote_table, remote_schema, servername, remote_type, 
cachingallowed, definer, remarks ) 
as select 
creator, name, definer, definertype, status, 
ctime, stats_time, colcount, fid, 
tid, card, npages, fpages, overflow, 
parents, children, selfrefs, 
keycolumns, keyobid, keyunique, checkcount, 
data_capture, const_checked, partition_mode, 
statistics_profile, 
access_mode, codepage, 
(select cast(setting as varchar(128)) from sysibm.systaboptions 
where name = tabname and creator = tabschema and option='REMOTE_TABLE'), 
(select cast(setting as varchar(128)) from sysibm.systaboptions 
where  name = tabname and creator = tabschema and option='REMOTE_SCHEMA') , 
(select cast(setting as varchar(128)) from sysibm.systaboptions 
where name = tabname and creator = tabschema and option='SERVER'), 
(select cast(setting as char(1)) from sysibm.systaboptions 
where name = tabname and creator = tabschema and option='REMOTE_TYPE'), 
CASE substr(property,11,1)  WHEN 'Y' THEN 'N' ELSE 'Y' END, 
definer, remarks 
from sysibm.systables  where type='N' 

;

-- View: SYSCAT.NODEGROUPDEF
CREATE VIEW SYSCAT.NODEGROUPDEF AS create or replace view syscat.nodegroupdef 
(ngname, nodenum, in_use) 
as select 
ngname, nodenum, in_use 
from sysibm.sysnodegroupdef
;

-- View: SYSCAT.NODEGROUPS
CREATE VIEW SYSCAT.NODEGROUPS AS create or replace view syscat.nodegroups 
(ngname, owner, ownertype, pmap_id, rebalance_pmap_id, create_time, 
definer, remarks) 
as select 
name, definer, definertype, pmap_id, rebalance_pmap_id, ctime, 
definer, remarks 
from sysibm.sysnodegroups
;

-- View: SYSCAT.PACKAGEAUTH
CREATE VIEW SYSCAT.PACKAGEAUTH AS create or replace view syscat.packageauth 
(grantor, grantortype, grantee, granteetype, pkgschema, pkgname, 
controlauth, bindauth, executeauth) 
as select 
grantor, grantortype, grantee, granteetype, creator, name, 
controlauth, bindauth, executeauth 
from sysibm.sysplanauth
;

-- View: SYSCAT.PACKAGEDEP
CREATE VIEW SYSCAT.PACKAGEDEP AS create or replace view syscat.packagedep 
(pkgschema, pkgname, binder, bindertype, btype, bschema, 
bmodulename, bname, bmoduleid, tabauth, varauth, unique_id, 
pkgversion) 
as select 
d.dcreator, d.dname, d.binder, d.bindertype, d.btype, d.bcreator, 
m.modulename, d.bname, d.bmoduleid, 
case when d.btype <> 'v' then d.tabauth else SMALLINT(0) end, 
case when d.btype = 'v' then d.tabauth else SMALLINT(0) end, d.dunique_id, 
(select p.pkgversion from sysibm.sysplan p 
where d.dcreator = p.creator 
and d.dname = p.name 
and d.dunique_id = p.unique_id) 
from sysibm.sysplandep d 
left outer join sysibm.sysmodules m on d.bmoduleid=m.moduleid 

;

-- View: SYSCAT.PACKAGES
CREATE VIEW SYSCAT.PACKAGES AS create or replace view syscat.packages 
(pkgschema, pkgname, boundby, boundbytype, owner, ownertype, default_schema, 
valid, 
unique_id, total_sect, format, isolation, concurrentaccessresolution, 
blocking, 
insert_buf, lang_level, func_path, queryopt, 
explain_level, explain_mode, explain_snapshot, sqlwarn, 
sqlmathwarn, create_time, explicit_bind_time, last_bind_time, alter_time, 
codepage, collationschema, collationname, 
collationschema_orderby, collationname_orderby, 
degree, multinode_plans, intra_parallel, validate, 
dynamicrules, sqlerror, refreshage, 
federated, transformgroup, reoptvar, 
os_ptr_size, pkgversion, 
staticreadonly, federated_asynchrony, 
anonblock, optprofileschema, optprofilename, 
pkgid, dbpartitionnum, 
definer, pkg_create_time, apreuse, extendedindicator, lastused, 
bustimesensitive, systimesensitive, 
keepdynamic, staticasdynamic, envstringunits, remarks, member) 
as select 
creator, name, boundby, boundbytype, boundby, boundbytype, default_schema, 
valid, 
unique_id, totalsect, format, isolation, concurrentaccessresolution, block, 
insert_buf, standards_level, func_path, queryopt, 
explain_level, explain_mode, explain_snapshot, sqlwarn, 
sqlmathwarn, pkg_create_time, explicit_bind_time, last_bind_time, alter_time, 
codepage, 
coalesce((select c1.collationschema from 
sysibm.syscollations as c1 
where p.collationid = c1.collationid), 
'SYSIBM'), 
coalesce((select c1.collationname from 
sysibm.syscollations as c1 
where p.collationid = c1.collationid), 
syscat.collationname(p.collationid)), 
coalesce((select c2.collationschema from 
sysibm.syscollations as c2 
where p.collationid_orderby = c2.collationid), 
'SYSIBM'), 
coalesce((select c2.collationname from 
sysibm.syscollations as c2 
where p.collationid_orderby = c2.collationid), 
syscat.collationname(p.collationid_orderby)), 
degree, multinode_plans, intra_parallel, validate, 
dynamicrules, sqlerror, refreshage, 
federated, transformgroup, reoptvar, 
os_ptr_size, pkgversion, 
staticreadonly, federated_asynchrony, 
anonblock, optprofileschema, optprofilename, 
pkgid, dbpartitionnum, 
boundby, pkg_create_time, apreuse, extendedindicator, lastused, 
bustimesensitive, systimesensitive, 
keepdynamic, staticasdynamic, 
cast(case 
when p.stringunits = 'S' then 'SYSTEM' 
when p.stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)), 
remarks, member 
from sysibm.sysplan p 
;

-- View: SYSCAT.PARTITIONMAPS
CREATE VIEW SYSCAT.PARTITIONMAPS AS create or replace view syscat.partitionmaps 
(pmap_id, partitionmap) 
as select 
pmap_id, partitionmap 
from sysibm.syspartitionmaps 
where pmap_id <> -2
;

-- View: SYSCAT.PASSTHRUAUTH
CREATE VIEW SYSCAT.PASSTHRUAUTH AS create or replace view syscat.passthruauth 
(grantor, grantortype, grantee, granteetype, servername) 
as select 
grantor, grantortype, grantee, granteetype, servername 
from sysibm.syspassthruauth
;

-- View: SYSCAT.PERIODS
CREATE VIEW SYSCAT.PERIODS AS create or replace view syscat.periods 
(periodname, tabschema, tabname, begincolname, endcolname, 
periodtype, historytabschema, historytabname) 
as select 
p.periodname, p.tabschema, p.tabname, 
(select c.name from sysibm.syscolumns c 
where c.tbname = p.tabname 
and c.tbcreator = p.tabschema 
and c.colno = p.begincolno), 
(select c.name from sysibm.syscolumns c 
where c.tbname = p.tabname 
and c.tbcreator = p.tabschema 
and c.colno = p.endcolno), 
case when p.periodtype = 1 then cast('S' as char(1)) 
else cast('A' as char(1)) 
end, 
t.creator, t.name 
from sysibm.sysperiods as p 
left outer join sysibm.systables as t 
on p.historytid = t.tid and p.historyfid = t.fid
;

-- View: SYSCAT.PREDICATESPECS
CREATE VIEW SYSCAT.PREDICATESPECS AS create or replace view syscat.predicatespecs 
(funcschema, funcname, specificname, funcid, specid, 
contextop, contextexp, filtertext) 
as select 
f.routineschema, f.routinename, f.specificname, p.funcid, p.specid, 
p.contextop, p.contextexp, CAST(p.filtertext as CLOB(32K)) 
from sysibm.sysroutines as f, 
sysibm.syspredicatespecs as p 
where f.routine_id=p.funcid 
and f.routinetype in ('F', 'M') 
and f.routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSCAT.PROCEDURES
CREATE VIEW SYSCAT.PROCEDURES AS create or replace view syscat.procedures 
(procschema, procname, specificname, procedure_id, 
definer, parm_count, parm_signature, origin, create_time, 
deterministic, fenced, nullcall, language, implementation, 
class, jar_id, parm_style, contains_sql, dbinfo, 
program_type, result_sets, valid, text_body_offset, text, 
remarks) 
as select 
a.routineschema, a.routinename, a.specificname, a.routine_id, 
a.definer, a.parm_count, a.parm_signature, a.origin, a.createdts, 
a.deterministic, a.fenced, a.null_call, a.language, a.implementation, 
(select pj.class from 
sysibm.sysroutineproperties as pj 
where pj.routine_id = a.routine_id), 
(SELECT pj.jar_id FROM 
SYSIBM.SYSROUTINEPROPERTIES AS pj 
WHERE pj.routine_id = a.routine_id), 
a.parameter_style, a.sql_data_access, a.dbinfo, 
a.program_type, a.result_sets, a.valid, a.text_body_offset, a.text, 
a.remarks 
from sysibm.sysroutines as a 
where a.routinetype in ('P') 
and a.routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSCAT.PROCPARMS
CREATE VIEW SYSCAT.PROCPARMS AS create or replace view syscat.procparms 
(procschema, procname, specificname, servername, ordinal, 
parmname, typeschema, typename, typeid, 
sourcetypeid, nulls, length, scale, 
parm_mode, codepage, dbcs_codepage, as_locator, 
target_typeschema, target_typename, 
scope_tabschema, scope_tabname) 
as select 
routineschema, routinename, specificname, cast(null as varchar(128)), ordinal, 
parmname, typeschema, typename, typeid, 
cast(null as smallint), cast ('Y' as char(1)), 
length, scale, 
CAST (CASE rowtype 
WHEN 'P' THEN 'IN' 
WHEN 'O' THEN 'OUT' 
ELSE 'INOUT' END AS VARCHAR(5)), 
codepage, cast(null as smallint), locator, target_typeschema, target_typename, 
scope_tabschema, scope_tabname 
from sysibm.sysroutineparms 
where routinetype in ('P') 
and routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSCAT.REFERENCES
CREATE VIEW SYSCAT.REFERENCES AS create or replace view syscat.references 
(constname, tabschema, tabname, owner, ownertype, refkeyname, 
reftabschema, reftabname, colcount, deleterule, updaterule, 
create_time, fk_colnames, pk_colnames, definer) 
as select 
relname, creator, tbname, definer, definertype, refkeyname, 
reftbcreator, reftbname, colcount, deleterule, updaterule, timestamp, 
coalesce(sysibm.deprecatedchar('-206', 'COLUMN', 
'SYSCAT.REFERENCES.FK_COLNAMES'), 
fkcolnames), 
coalesce(sysibm.deprecatedchar('-206', 'COLUMN', 
'SYSCAT.REFERENCES.PK_COLNAMES'), 
pkcolnames), 
definer 
from sysibm.sysrels
;

-- View: SYSCAT.ROLEAUTH
CREATE VIEW SYSCAT.ROLEAUTH AS create or replace view syscat.roleauth 
(grantor, grantortype, grantee, granteetype, rolename, roleid, admin) 
as select 
grantor, grantortype, grantee, granteetype, rolename, roleid, admin 
from sysibm.sysroleauth 
where rolename not LIKE 'SYSROLE%'
;

-- View: SYSCAT.ROLES
CREATE VIEW SYSCAT.ROLES AS create or replace view syscat.roles 
(rolename, roleid, create_time, auditpolicyid, 
auditpolicyname, auditexceptionenabled, remarks) 
as select 
a.rolename, a.roleid, a.create_time, a.auditpolicyid, 
case when a.auditpolicyid is null then null 
else (select auditpolicyname from sysibm.sysauditpolicies aud 
where a.auditpolicyid = aud.auditpolicyid) 
end, 
a.auditexceptionenabled, b.remarks 
from sysibm.sysroles as a left outer join sysibm.syscomments as b 
on a.roleid = b.objectid and b.objecttype='r' 
where a.rolename not LIKE 'SYSROLE%'
;

-- View: SYSCAT.ROUTINEAUTH
CREATE VIEW SYSCAT.ROUTINEAUTH AS create or replace view syscat.routineauth 
(grantor, grantortype, grantee, granteetype, schema, specificname, 
typeschema, typename, routinetype, executeauth, grant_time) 
as select 
grantor, grantortype, grantee, granteetype, schema, specificname, 
typeschema, typename, routinetype, executeauth, grant_time 
from sysibm.sysroutineauth 
where schema not in ('SYSIBMINTERNAL') and 
not (grantee LIKE 'SYSROLE%' and granteetype='R')
;

-- View: SYSCAT.ROUTINEDEP
CREATE VIEW SYSCAT.ROUTINEDEP AS create or replace view syscat.routinedep 
(routineschema, routinemodulename, specificname, routinemoduleid, 
btype, bschema, bmodulename, bname, bmoduleid, tabauth, routinename) 
as select 
dschema, md.modulename, dname, dmoduleid, 
btype, bschema, mb.modulename, bname, bmoduleid, tabauth, 
coalesce(sysibm.deprecatedchar('-206', 'COLUMN', 
'SYSCAT.ROUTINEDEP.ROUTINENAME'), dname) 
from sysibm.sysdependencies 
left outer join sysibm.sysmodules md on dmoduleid=md.moduleid 
left outer join sysibm.sysmodules mb on bmoduleid=mb.moduleid 
where dtype = 'F' 
and dschema not in ('SYSIBMINTERNAL')
;

-- View: SYSCAT.ROUTINEOPTIONS
CREATE VIEW SYSCAT.ROUTINEOPTIONS AS create or replace view syscat.routineoptions 
(routineschema, routinemodulename, routinename, specificname, option, setting) 
as select 
r.routineschema, m.modulename, r.routinename, 
r.specificname, ro.option, ro.setting 
from (sysibm.sysroutineoptions ro 
left outer join sysibm.sysroutines r on ro.routineid = r.routine_id) 
left outer join sysibm.sysmodules m on r.routinemoduleid = m.moduleid 
where r.routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSCAT.ROUTINEPARMOPTIONS
CREATE VIEW SYSCAT.ROUTINEPARMOPTIONS AS create or replace view syscat.routineparmoptions 
(routineschema, routinename, specificname, ordinal, option, setting) 
as select 
a.routineschema, a.routinename, a.specificname, b.ordinal, b.option, b.setting 
from sysibm.sysroutines a , sysibm.sysroutineparmoptions b 
where a.routine_id = b.routineid 
and a.routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSCAT.ROUTINEPARMS
CREATE VIEW SYSCAT.ROUTINEPARMS AS create or replace view syscat.routineparms 
(routineschema, routinemodulename, routinename, routinemoduleid, 
specificname, parmname, rowtype, ordinal, typeschema, typemodulename, 
typename, locator, length, scale, typestringunits, stringunitslength, 
codepage, 
collationschema, collationname, 
cast_funcschema, cast_funcspecific, target_typeschema, target_typemodulename, 
target_typename, scope_tabschema, scope_tabname, 
transformgrpname, default, remarks) 
as select 
r.routineschema, m.modulename, r.routinename, r.routinemoduleid, 
r.specificname, rp.parmname, rp.rowtype, rp.ordinal, d.schema, 
mt.modulename, d.name, rp.locator, rp.length, 
CASE WHEN (rp.codepage=1208 or rp.codepage=1200) and rp.scale<>0 THEN 
CAST(0 as SMALLINT) 
ELSE rp.scale END, 
CASE WHEN rp.codepage=1208 and rp.scale=0 THEN CAST('OCTETS' as VARCHAR(11)) 
WHEN rp.codepage=1208 and rp.scale=4 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
WHEN rp.codepage=1200 and rp.scale=0 THEN CAST('CODEUNITS16' as 
VARCHAR(11)) 
WHEN rp.codepage=1200 and rp.scale=2 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
ELSE CAST(NULL AS VARCHAR(11)) END, 
CASE WHEN (rp.codepage=1208 or rp.codepage=1200) and rp.scale=0 THEN rp.length 
WHEN (rp.codepage=1208 or rp.codepage=1200) and rp.scale<>0 THEN 
CAST(rp.length/rp.scale as INTEGER) 
ELSE CAST(NULL AS INTEGER) END, 
rp.codepage, 
case when rp.collationid is null then null 
else coalesce(c.collationschema, 'SYSIBM') end, 
case when rp.collationid is null then null 
else coalesce(c.collationname, syscat.collationname(rp.collationid)) end, 
rcast.routineschema, rcast.specificname, 
dtarget.schema, mtt.modulename, dtarget.name, rp.scope_tabschema, 
rp.scope_tabname, rp.transform_grpname, rp.default, 
rp.remarks 
from (((((sysibm.sysroutineparms as rp 
left outer join sysibm.sysroutines as r on rp.routine_id = r.routine_id) 
left outer join sysibm.sysdatatypes as d on rp.typeid = d.typeid) 
left outer join sysibm.sysroutines as rcast 
on rcast.routine_id = rp.cast_function_id) 
left outer join sysibm.sysdatatypes as dtarget 
on dtarget.typeid = rp.target_typeid) 
left outer join sysibm.syscollations as c 
on rp.collationid = c.collationid) 
left outer join sysibm.sysmodules m on r.routinemoduleid = m.moduleid 
left outer join sysibm.sysmodules mt on rp.typemoduleid = mt.moduleid 
left outer join sysibm.sysmodules mtt on 
rp.target_typemoduleid = mtt.moduleid 
where rp.routineschema not in ('SYSIBMINTERNAL') 
union all select 
routineschema, routinemodulename, routinename, routinemoduleid, 
specificname, parmname, rowtype, ordinal, typeschema, typemodulename, 
typename, locator, length, scale, typestringunits, stringunitslength, 
codepage, 
collationschema, collationname, 
cast_funcschema, cast_funcspecific, target_typeschema, target_typemodulename, 
target_typename, scope_tabschema, scope_tabname, 
transformgrpname, default, remarks 
from table(sysproc.admin_get_sysibm_function_parms(NULL,NULL)) 

;

-- View: SYSCAT.ROUTINES
CREATE VIEW SYSCAT.ROUTINES AS create or replace view syscat.routines 
(routineschema, routinemodulename, routinename, routinetype, 
owner, ownertype, 
specificname, routineid, routinemoduleid, return_typeschema, 
return_typemodule, return_typename, origin, functiontype, 
parm_count, language, dialect, sourceschema, sourcemodulename, sourcespecific, published, 
deterministic, external_action, nullcall, cast_function, 
assign_function, scratchpad, scratchpad_length, 
finalcall, parallel, parameter_style, fenced, 
sql_data_access, dbinfo, programtype, commit_on_return, autonomous, 
result_sets, spec_reg, federated, threadsafe, valid, 
moduleroutineimplemented, methodimplemented, methodeffect, type_preserving, 
with_func_access, overridden_methodid, subject_typeschema, 
subject_typename, class, jar_id, jarschema, jar_signature, 
create_time, alter_time, func_path, qualifier, 
ios_per_invoc, insts_per_invoc, ios_per_argbyte, 
insts_per_argbyte, percent_argbytes, initial_ios, 
initial_insts, cardinality, selectivity, result_cols, 
implementation, lib_id, text_body_offset, text, newsavepointlevel, 
debug_mode, trace_level, diagnostic_level, checkout_userid, 
precompile_options, compile_options, execution_control, 
codepage, collationschema, 
collationname, collationschema_orderby, collationname_orderby, 
encoding_scheme, last_regen_time, inheritlockrequest, 
definer, secure, envstringunits, remarks) 
as select 
a.routineschema, m.modulename, a.routinename, a.routinetype, 
a.definer, a.definertype, 
a.specificname, a.routine_id, a.routinemoduleid, 
( select schema from sysibm.sysdatatypes 
where return_type = typeid ), 
( select m1.modulename 
from sysibm.sysdatatypes d left outer join sysibm.sysmodules m1 
on d.typemoduleid = m1.moduleid 
where a.return_type = d.typeid), 
( select name from sysibm.sysdatatypes 
where return_type = typeid ), 
a.origin, a.function_type, 
a.parm_count, a.language, 
CAST (CASE 
WHEN a.dialect = '1' THEN 'DB2 SQL PL' 
WHEN a.dialect = '2' THEN 'PL/SQL' 
ELSE ' ' 
END AS VARCHAR(10)), 
a.sourceschema, 
case when a.origin='U' and a.sourceschema<>'SYSIBM' then 
(select sm.modulename from sysibm.sysmodules sm 
where sm.moduleid= 
(select sr.routinemoduleid from sysibm.sysroutines sr 
where sr.routine_id=a.sourceroutineid)) 
else null end, 
a.sourcespecific, a.published, 
a.deterministic, a.external_action, a.null_call, a.cast_function, 
a.assign_function, a.scratchpad, a.scratchpad_length, 
a.final_call, a.parallel, a.parameter_style, a.fenced, 
a.sql_data_access, a.dbinfo, a.program_type, a.commit_on_return, a.autonomous, 
a.result_sets, a.spec_reg, a.federated, a.threadsafe, a.valid, 
cast(case when a.routinemoduleid is not null then a.methodimplemented 
else ' ' end as char(1)), 
cast(case when a.routinemoduleid is null then a.methodimplemented 
else ' ' end as char(1)), 
a.methodeffect, a.type_preserving, 
a.with_func_access, a.overridden_methodid, a.subject_typeschema, 
a.subject_typename, b.class, b.jar_id, b.jarschema, b.jar_signature, 
a.createdts, a.alteredts, a.func_path, a.qualifier, a.ios_per_invoc, 
a.insts_per_invoc, a.ios_per_argbyte, a.insts_per_argbyte, 
a.percent_argbytes, a.initial_ios, a.initial_insts, a.cardinality, 
a.selectivity, a.result_cols, a.implementation, a.lib_id, 
a.text_body_offset, a.text, a.newsavepointlevel, 
cast (case 
when a.debug_mode = '0' then 'DISALLOW' 
when a.debug_mode = '1' then 'ALLOW' 
when a.debug_mode = 'N' then 'DISABLE' 
else a.debug_mode end as varchar(8)), 
cast (case when c.trace_level is null then '0' 
else c.trace_level end as varchar(1)), 
cast (case when c.diagnostic_level is null then '0' 
else c.diagnostic_level end as varchar(1)), 
c.checkout_userid, c.precompile_options, 
c.compile_options, a.execution_control, a.codepage, 
coalesce(c1.collationschema, 'SYSIBM'), 
coalesce(c1.collationname, syscat.collationname(a.collationid)), 
coalesce(c2.collationschema, 'SYSIBM'), 
coalesce(c2.collationname, syscat.collationname(a.collationid_orderby)), 
a.encoding_scheme, a.last_regen_time, a.inheritlockrequest, 
a.definer, a.secure, 
cast(case 
when a.stringunits = 'S' then 'SYSTEM' 
when a.stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)), 
a.remarks 
from (sysibm.sysroutines as a 
left outer join sysibm.sysroutineproperties as b 
on a.routine_id = b.routine_id ) 
left outer join sysibm.syscodeproperties as c 
on a.routine_id = c.object_id 
and c.object_type = 'F' 
left outer join sysibm.syscollations as c1 
on a.collationid = c1.collationid 
left outer join sysibm.syscollations as c2 
on a.collationid_orderby = c2.collationid 
left outer join sysibm.sysmodules m 
on a.routinemoduleid = m.moduleid 
where a.routineschema not in ('SYSIBMINTERNAL') 
union all select 
routineschema, routinemodulename, routinename, routinetype, 
owner, ownertype, 
specificname, routineid, routinemoduleid, return_typeschema, 
return_typemodule, return_typename, origin, functiontype, 
parm_count, language, dialect, sourceschema, sourcemodulename, sourcespecific, published, 
deterministic, external_action, nullcall, cast_function, 
assign_function, scratchpad, scratchpad_length, 
finalcall, parallel, parameter_style, fenced, 
sql_data_access, dbinfo, programtype, commit_on_return, autonomous, 
result_sets, spec_reg, federated, threadsafe, valid, 
moduleroutineimplemented, methodimplemented, methodeffect, type_preserving, 
with_func_access, overridden_methodid, subject_typeschema, 
subject_typename, class, jar_id, jarschema, jar_signature, 
create_time, alter_time, func_path, qualifier, 
ios_per_invoc, insts_per_invoc, ios_per_argbyte, 
insts_per_argbyte, percent_argbytes, initial_ios, 
initial_insts, cardinality, selectivity, result_cols, 
implementation, lib_id, text_body_offset, text, newsavepointlevel, 
debug_mode, trace_level, diagnostic_level, checkout_userid, 
precompile_options, compile_options, execution_control, 
codepage, collationschema, 
collationname, collationschema_orderby, collationname_orderby, 
encoding_scheme, last_regen_time, inheritlockrequest, 
definer, secure, envstringunits, remarks 
from table(sysproc.admin_get_sysibm_functions(NULL,NULL)) 

;

-- View: SYSCAT.ROUTINESFEDERATED
CREATE VIEW SYSCAT.ROUTINESFEDERATED AS create or replace view syscat.routinesfederated 
(routineschema, routinename, routinetype, owner, ownertype, 
specificname, routineid, 
parm_count, 
deterministic, external_action, 
sql_data_access, commit_on_return, 
result_sets, 
create_time, alter_time, qualifier, 
result_cols, 
codepage, last_regen_time, 
remote_procedure, remote_schema, servername, 
remote_package , remote_procedure_alter_time, remarks ) 
as select 
routineschema, routinename, routinetype, definer, definertype, 
specificname, routine_id, 
parm_count, 
deterministic, external_action, 
sql_data_access, commit_on_return, 
result_sets, 
createdts, alteredts, qualifier, 
result_cols,  codepage, 
last_regen_time, 
(select cast(setting as varchar(128)) from sysibm.sysroutineoptions 
where routine_id =routineid and option='REMOTE_PROCEDURE'), 
(select cast(setting as varchar(128)) from sysibm.sysroutineoptions 
where routine_id =routineid and option='REMOTE_SCHEMA') , 
(select cast(setting as varchar(128)) from sysibm.sysroutineoptions 
where routine_id =routineid and option='SERVER'), 
(select cast(setting as varchar(128)) from sysibm.sysroutineoptions 
where routine_id =routineid and option='REMOTE_PACKAGE'), 
(select cast(setting as varchar(128)) from sysibm.sysroutineoptions 
where routine_id =routineid and option='ALTERED_TIMESTAMP'), 
remarks 
from sysibm.sysroutines where origin ='F' 
and routineschema not in ('SYSIBMINTERNAL') 

;

-- View: SYSCAT.ROWFIELDS
CREATE VIEW SYSCAT.ROWFIELDS AS create or replace view syscat.rowfields 
(typeschema, typemodulename, typename, fieldname, fieldtypeschema, 
fieldtypemodulename, fieldtypename, ordinal, length, scale, 
typestringunits, stringunitslength, 
codepage, collationschema, collationname, nulls, qualifier, 
func_path, default, envstringunits) 
as select 
a.typeschema, m.modulename, a.typename, a.attr_name, a.attr_typeschema, 
ma.modulename, a.attr_typename, 
a.ordinal, a.length, 
CASE WHEN (a.codepage=1208 or a.codepage=1200) and a.scale<>0 THEN CAST(0 as 
SMALLINT) 
ELSE a.scale END, 
CASE WHEN a.codepage=1208 and a.scale=0 THEN CAST('OCTETS' as VARCHAR(11)) 
WHEN a.codepage=1208 and a.scale=4 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
WHEN a.codepage=1200 and a.scale=0 THEN CAST('CODEUNITS16' as 
VARCHAR(11)) 
WHEN a.codepage=1200 and a.scale=2 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
ELSE CAST(NULL AS VARCHAR(11)) END, 
CASE WHEN (a.codepage=1208 or a.codepage=1200) and a.scale=0 THEN a.length 
WHEN (a.codepage=1208 or a.codepage=1200) and a.scale<>0 THEN 
CAST(a.length/a.scale as INTEGER) 
ELSE CAST(NULL AS INTEGER) END, 
a.codepage, 
case when a.collationid is null then null 
else coalesce(c.collationschema, 'SYSIBM') end, 
case when a.collationid is null then null 
else coalesce(c.collationname, syscat.collationname(a.collationid)) end, 
a.nulls, a.qualifier, a.func_path, a.default, 
cast(case 
when a.stringunits = 'S' then 'SYSTEM' 
when a.stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)) 
from sysibm.sysattributes as a 
inner join sysibm.sysdatatypes as d on d.metatype='F' and 
a.typename = d.name and a.typeschema = d.schema and 
(a.typemoduleid = d.typemoduleid or a.typemoduleid is null and 
d.typemoduleid is null) 
left outer join sysibm.syscollations as c on a.collationid = c.collationid 
left outer join sysibm.sysmodules m  on a.typemoduleid=m.moduleid 
left outer join sysibm.sysmodules ma on a.attr_typemoduleid=ma.moduleid 

;

-- View: SYSCAT.SCHEMAAUTH
CREATE VIEW SYSCAT.SCHEMAAUTH AS create or replace view syscat.schemaauth 
(grantor, grantortype, grantee, granteetype, schemaname, alterinauth, 
createinauth, dropinauth, selectinauth, insertinauth, updateinauth, 
deleteinauth, executeinauth, schemaadmauth, accessctrlauth, 
dataaccessauth, loadauth, schemarcacauth) 
as select 
grantor, grantortype, grantee, granteetype, schemaname, alterinauth, 
createinauth, dropinauth, selectinauth, insertinauth, updateinauth, 
deleteinauth, executeinauth, 
case when schemaadmauth = 'Z' or schemaadmauth = 'Y' then 'Y' 
else 'N' 
end, 
accessctrlauth, 
dataaccessauth, loadauth, 
case when schemaadmauth = 'Z' or schemaadmauth = 'O' then 'Y' 
else 'N' 
end 
from sysibm.sysschemaauth
;

-- View: SYSCAT.SCHEMATA
CREATE VIEW SYSCAT.SCHEMATA AS create or replace view syscat.schemata 
(schemaname, owner, ownertype, definer, definertype, create_time, 
auditpolicyid, auditpolicyname, auditexceptionenabled, datacapture, 
rowmodificationtracking, quiesced, remarks) 
as select 
a.name, a.owner, 
case when a.ownertype = 'S' or a.ownertype = 'M' then 'S' 
else 'U' 
end, 
a.definer, a.definertype, a.create_time, 
a.auditpolicyid, 
case when a.auditpolicyid is null then null 
else (select auditpolicyname from sysibm.sysauditpolicies aud 
where a.auditpolicyid = aud.auditpolicyid) 
end, 
a.auditexceptionenabled, 
case when a.datacapture = 'Y' or a.datacapture = 'A' then 'Y' 
else 'N' 
end, 
case when a.datacapture = 'T' or a.datacapture = 'A' then 'Y' 
else 'N' 
end, 
case when a.ownertype = 'M' or a.ownertype = 'N' then 'Y' 
else 'N' 
end, 
a.remarks 
from sysibm.sysschemata as a
;

-- View: SYSCAT.SCPREFTBSPACES
CREATE VIEW SYSCAT.SCPREFTBSPACES AS create or replace view syscat.scpreftbspaces 
(serviceclassname, parentserviceclassname, tbspace, serviceclassid, 
parentserviceclassid, tbspaceid, datatype) 
as select 
b.serviceclassname, d.serviceclassname, c.tbspace, a.serviceclassid, 
d.serviceclassid, a.tbspaceid, c.datatype 
from (sysibm.sysscpreftbspaces as a left outer join 
sysibm.sysserviceclasses as b on a.serviceclassid = b.serviceclassid 
left outer join sysibm.systablespaces as c on a.tbspaceid = c.tbspaceid 
left outer join sysibm.sysserviceclasses as d on 
b.parentid = d.serviceclassid)
;

-- View: SYSCAT.SECURITYLABELACCESS
CREATE VIEW SYSCAT.SECURITYLABELACCESS AS create or replace view syscat.securitylabelaccess 
(grantor, grantee, granteetype, seclabelid, secpolicyid, 
accesstype, grant_time) 
as (select grantor, grantee, granteetype, seclabelid, 
secpolicyid, accesstype, grant_time 
from sysibm.syssecuritylabelaccess)
;

-- View: SYSCAT.SECURITYLABELCOMPONENTELEMENTS
CREATE VIEW SYSCAT.SECURITYLABELCOMPONENTELEMENTS AS create or replace view syscat.securitylabelcomponentelements 
(compid, elementvalue, elementvalueencoding,parentelementvalue) 
as( select compid, elementvalue, elementvalueencoding,parentelementvalue 
from sysibm.syssecuritylabelcomponentelements)
;

-- View: SYSCAT.SECURITYLABELCOMPONENTS
CREATE VIEW SYSCAT.SECURITYLABELCOMPONENTS AS create or replace view syscat.securitylabelcomponents 
(compname, compid, comptype, numelements, create_time, remarks ) 
as (select 
a.compname, a.compid, a.comptype, a.numelements, a.create_time, c.remarks 
from sysibm.syssecuritylabelcomponents as a left outer join 
sysibm.syscomments as c on c.objecttype='d' and c.objectid=a.compid) 
;

-- View: SYSCAT.SECURITYLABELS
CREATE VIEW SYSCAT.SECURITYLABELS AS create or replace view syscat.securitylabels 
(seclabelname, seclabelid, secpolicyid, seclabel, create_time, remarks) 
as (select a.seclabelname, a.seclabelid, a.secpolicyid, 
CAST (a.seclabel_internal as SYSPROC.DB2SECURITYLABEL ), 
a.create_time, c.remarks 
from  sysibm.syssecuritylabels as a left outer join sysibm.syscomments as c 
on c.objecttype='l' and c.objectid=a.seclabelid)
;

-- View: SYSCAT.SECURITYPOLICIES
CREATE VIEW SYSCAT.SECURITYPOLICIES AS create or replace view syscat.securitypolicies 
(secpolicyname, secpolicyid, numseclabelcomp, rwseclabelrel, 
notauthwriteseclabel, create_time, groupauths, 
roleauths, remarks ) 
as (select a.secpolicyname, a.secpolicyid, a.numseclabelcomp, a.rwseclabelrel, 
a.notauthwriteseclabel, a.create_time, a.groupauths, 
a.roleauths, c.remarks 
from sysibm.syssecuritypolicies as a left outer join sysibm.syscomments as c 
on c.objecttype='p' and c.objectid=a.secpolicyid)
;

-- View: SYSCAT.SECURITYPOLICYCOMPONENTRULES
CREATE VIEW SYSCAT.SECURITYPOLICYCOMPONENTRULES AS create or replace view syscat.securitypolicycomponentrules 
(secpolicyid, compid, ordinal, readaccessrulename, readaccessruletext, 
writeaccessrulename, writeaccessruletext) 
as (select secpolicyid, compid, ordinal, readaccessrulename, 
readaccessruletext, writeaccessrulename, writeaccessruletext 
from sysibm.syssecuritypolicycomponentrules)
;

-- View: SYSCAT.SECURITYPOLICYEXEMPTIONS
CREATE VIEW SYSCAT.SECURITYPOLICYEXEMPTIONS AS create or replace view syscat.securitypolicyexemptions 
(grantor, grantee, granteetype, secpolicyid, accessrulename, 
accesstype, ordinal, actionallowed, grant_time) 
as (select grantor, grantee, granteetype, secpolicyid, 
accessrulename, accesstype, ordinal, actionallowed, grant_time 
from sysibm.syssecuritypolicyexemptions)
;

-- View: SYSCAT.SEQUENCEAUTH
CREATE VIEW SYSCAT.SEQUENCEAUTH AS create or replace view syscat.sequenceauth 
(grantor, grantortype, grantee, granteetype, seqschema, seqname, 
alterauth, usageauth) 
as select 
a.grantor, a.grantortype, a.grantee, a.granteetype, b.seqschema, b.seqname, 
a.alterauth, a.usageauth 
from sysibm.syssequenceauth as a, sysibm.syssequences as b 
where a.seqid = b.seqid
;

-- View: SYSCAT.SEQUENCES
CREATE VIEW SYSCAT.SEQUENCES AS create or replace view syscat.sequences 
(seqschema, seqname, definer, definertype, owner, ownertype, seqid, seqtype, 
base_seqschema, base_seqname, 
increment, start, maxvalue, minvalue, nextcachefirstvalue, cycle, cache, 
order, datatypeid, sourcetypeid, create_time, alter_time, 
precision, origin, remarks) 
as select 
a.seqschema, a.seqname, a.definer, a.definertype, a.owner, a.ownertype, 
a.seqid, a.seqtype, a.base_seqschema, a.base_seqname, a.increment, a.start, 
a.maxvalue, a.minvalue, 
cast(case when a.lastassignedval + a.increment > a.maxvalue 
and a.increment > 0 
then case when a.cycle = 'Y' then a.minvalue else null end 
when a.lastassignedval + a.increment < a.minvalue 
and a.increment < 0 
then case when a.cycle = 'Y' then a.maxvalue else null end 
else coalesce(a.lastassignedval + a.increment, a.start) end as decimal(31)), 
a.cycle, a.cache, 
a.order, a.datatypeid, a.sourcetypeid, a.create_time, 
a.alter_time, a.precision, a.origin, b.remarks 
from sysibm.syssequences as a left outer join 
sysibm.syscomments as b 
on a.seqid = b.objectid and b.objecttype = 'Q'
;

-- View: SYSCAT.SERVEROPTIONS
CREATE VIEW SYSCAT.SERVEROPTIONS AS create or replace view syscat.serveroptions 
(wrapname, servername, servertype, serverversion, 
create_time, option, setting, serveroptionkey, remarks) 
as select 
wrapname, servername, servertype, serverversion, 
create_time, option, setting, serveroptionkey, remarks 
from sysibm.sysserveroptions
;

-- View: SYSCAT.SERVERS
CREATE VIEW SYSCAT.SERVERS AS create or replace view syscat.servers 
(wrapname, servername, servertype, serverversion, remarks) 
as select 
wrapname, servername, servertype, serverversion, remarks 
from sysibm.sysservers
;

-- View: SYSCAT.SERVICECLASSES
CREATE VIEW SYSCAT.SERVICECLASSES AS create or replace view syscat.serviceclasses 
(serviceclassname, parentserviceclassname, serviceclassid, parentid, 
create_time, 
alter_time, enabled, agentpriority, prefetchpriority, maxdegree, 
bufferpoolpriority, inboundcorrelator, 
outboundcorrelator, collectaggactdata, collectaggreqdata, collectactdata, 
collectactpartition, collectreqmetrics, cpushares, cpusharetype, cpulimit, 
sortmemorypriority, sectionactualsoptions, collectagguowdata, 
resourceshares, resourcesharetype, minresourcesharepct, 
admissionqueueorder, degreescaleback, 
workloadtype, 
collecthistory, actsortmemlimit, remarks) 
as select 
a.serviceclassname, b.serviceclassname, a.serviceclassid, a.parentid, 
a.create_time, a.alter_time, a.enabled, a.agentpriority, 
a.prefetchpriority, a.maxdegree, a.bufferpoolpriority, 
a.inboundcorrelator, a.outboundcorrelator, a.collectaggactdata, 
a.collectaggreqdata, a.collectactdata, a.collectactpartition, 
a.collectreqmetrics, a.cpushares, a.cpusharetype, a.cpulimit, 
a.sortmemorypriority, a.sectionactualsoptions, a.collectagguowdata, 
a.resourceshares, a.resourcesharetype, 
case when a.minresourcesharepct <> -1 then a.minresourcesharepct else SMALLINT(0) end, 
a.admissionqueueorder, a.degreescaleback, a.workloadtype, 
cast ( case 
when a.collectactdata = 'N' then 'N' 
when a.collectactdata = 'D' and a.collectactpartition = 'C' then 'Y' 
else NULL end as char(1)), 
SYSIBMINTERNAL.WLM_GET_SC_SORT_MEM_LIMIT(a.SERVICECLASS_DESC), 
c.remarks 
from ( sysibm.sysserviceclasses as a 
left outer join sysibm.sysserviceclasses as b 
on a.parentid = b.serviceclassid 
left outer join sysibm.syscomments as c 
on c.objecttype = 'b' and c.objectid = a.serviceclassid )
;

-- View: SYSCAT.STATEMENTS
CREATE VIEW SYSCAT.STATEMENTS AS create or replace view syscat.statements 
(pkgschema, pkgname, stmtno, sectno, seqno, text, unique_id, version) 
as select 
s.plcreator, s.plname, 
s.stmtno, s.sectno, 1, s.text, s.unique_id, 
(select p.pkgversion from sysibm.sysplan p 
where s.plcreator = p.creator 
and s.plname = p.name 
and s.unique_id = p.unique_id) 
from sysibm.sysstmt s
;

-- View: SYSCAT.STATEMENTTEXTS
CREATE VIEW SYSCAT.STATEMENTTEXTS AS create or replace view syscat.statementtexts 
(textid, text) 
as select 
t.textid, t.text 
from sysibm.sysstatementtexts t
;

-- View: SYSCAT.STOGROUPS
CREATE VIEW SYSCAT.STOGROUPS AS create or replace view syscat.stogroups 
(sgname, sgid, owner, create_time, defaultsg,  overhead, devicereadrate, 
writeoverhead, devicewriterate, datatag, cachingtier, remarks) 
as select 
a.sgname, a.sgid, a.owner, a.create_time, a.defaultsg, a.overhead, 
a.devicereadrate, a.writeoverhead, a.devicewriterate, a.datatag, 
cast( case 
when a.cachingtier = 0 then 'DISABLED' 
else 'ENABLED' 
end as varchar(8)), 
b.remarks 
from sysibm.sysstogroups a 
left outer join sysibm.syscomments b 
on a.sgid = b.objectid and b.objecttype = 't'
;

-- View: SYSCAT.SURROGATEAUTHIDS
CREATE VIEW SYSCAT.SURROGATEAUTHIDS AS create or replace view syscat.surrogateauthids 
(grantor, trustedid,  trustedidtype, surrogateauthid, 
surrogateauthidtype, authenticate, contextrole, grant_time) 
as (select grantor, trustedid,  trustedidtype, surrogateauthid, 
surrogateauthidtype, authenticate, contextrole, grant_time 
from sysibm.syssurrogateauthids)
;

-- View: SYSCAT.SYSCOLPROPERTIES_UNION
CREATE VIEW SYSCAT.SYSCOLPROPERTIES_UNION AS CREATE OR REPLACE VIEW SYSCAT.SYSCOLPROPERTIES_UNION 
( colname, tabname, tabschema, target_typeschema, target_typename, 
scope_tabschema, scope_tabname, special_props) 
as 
select colname, tabname, tabschema, target_typeschema, target_typename, 
scope_tabschema, scope_tabname, special_props 
from sysibm.syscolproperties 

;

-- View: SYSCAT.SYSCOLUMNS_UNION
CREATE VIEW SYSCAT.SYSCOLUMNS_UNION AS CREATE OR REPLACE VIEW SYSCAT.SYSCOLUMNS_UNION 
(name, tbcreator, tbname, coltype, nulls, codepage, dbcscodepg, 
length, scale, colno, colcard, high2key, low2key, avgcollen, keyseq, 
typename, typeschema, longlength, logged, compact, nquantiles, nmostfreq, 
composite_codepage, partkeyseq, source_tabschema, source_tabname, hidden, 
generated, inline_length, numnulls, avgcollenchar, sub_count, 
sub_delim_length, identity, compress, avgdistinctperpage, pagevarianceratio, 
implicitvalue, seclabelid, collationid, pctinlined, pctencoded, 
avgencodedcollen, remarks, default) 
as 
select name, tbcreator, tbname, coltype, nulls, codepage, dbcscodepg, 
length, scale, colno, colcard, high2key, low2key, avgcollen, keyseq, 
typename, typeschema, longlength, logged, compact, nquantiles, 
nmostfreq, composite_codepage, partkeyseq, source_tabschema, 
source_tabname, hidden, generated, inline_length, numnulls, 
avgcollenchar, sub_count, sub_delim_length, identity, compress, 
avgdistinctperpage, pagevarianceratio, implicitvalue, seclabelid, 
collationid, pctinlined, pctencoded, avgencodedcollen, remarks, default 
from sysibm.syscolumns 

;

-- View: SYSCAT.SYSDATATYPES_UNION
CREATE VIEW SYSCAT.SYSDATATYPES_UNION AS CREATE OR REPLACE VIEW SYSCAT.SYSDATATYPES_UNION 
(schema, name, sourceschema, sourcetype, metatype, typeid, 
sourcetypeid, sourcemoduleid, definer, definertype, published, length, 
scale, stringunits, codepage, collationid, array_length, arrayindextypeid, 
arrayindextypescale, create_time, alter_time, valid, attrcount, 
instantiable, with_func_access, final, inline_length, natural_inline_length, 
jarschema, jar_id, class, sqlj_representation, typemoduleid, nulls, envid, 
remarks, packed_desc, type_desc, func_path, constraint_text) 
as 
select 
schema, name, sourceschema, sourcetype, metatype, typeid, 
sourcetypeid, sourcemoduleid, definer, definertype, published, length, 
scale, stringunits, codepage, collationid, array_length, 
arrayindextypeid, arrayindextypescale, create_time, alter_time, valid, 
attrcount, instantiable, with_func_access, final, inline_length, 
natural_inline_length, jarschema, jar_id, class, sqlj_representation, 
typemoduleid, nulls, envid, remarks, 
packed_desc, type_desc, func_path, constraint_text 
from sysibm.sysdatatypes 

;

-- View: SYSCAT.SYSTABLES_UNION
CREATE VIEW SYSCAT.SYSTABLES_UNION AS CREATE OR REPLACE VIEW SYSCAT.SYSTABLES_UNION 
(creator, name, definer, definertype, type, status, 
base_schema, base_name, rowtypeschema, rowtypename, ctime, alter_time, 
invalidate_time, stats_time, colcount, fid, tid, card, npages, mpages, fpages, 
overflow, tbspace, index_tbspace, long_tbspace, parents, children, selfrefs, 
keycolumns, keyobid, keyunique, checkcount, data_capture, const_checked, 
pmap_id, partition_mode, pctfree, append_mode, refresh, refresh_time, locksize, 
volatile, property, compression, rowcompmode, access_mode, clustered, 
active_blocks, droprule, maxfreespacesearch, avgcompressedrowsize, 
avgrowcompressionratio, avgrowsize, pctrowscompressed, logindexbuild, codepage, 
collationid, collationid_orderby, encoding_scheme, pctpagessaved, 
last_regen_time, secpolicyid, protectiongranularity, auditpolicyid, 
auditexceptionenabled, oncommit, logged, onrollback, lastused, control, 
extended_row_size, pctextendedrows, remarks, 
packed_desc, view_desc, rel_desc, check_desc, trig_desc, remote_desc, 
ast_desc, statistics_profile, controls_desc, auditexception_desc) 
as 
select creator, name, definer, definertype, type, 
status, base_schema, base_name, rowtypeschema, rowtypename, ctime, 
alter_time, invalidate_time, stats_time, colcount, fid, tid, card, 
npages, mpages, fpages, overflow, tbspace, index_tbspace, long_tbspace, 
parents, children, selfrefs, keycolumns, keyobid, keyunique, checkcount, 
data_capture, const_checked, pmap_id, partition_mode, pctfree, 
append_mode, refresh, refresh_time, locksize, volatile, property, 
compression, rowcompmode, access_mode, clustered, active_blocks, 
droprule, maxfreespacesearch, avgcompressedrowsize, 
avgrowcompressionratio, avgrowsize, pctrowscompressed, logindexbuild, 
codepage, collationid, collationid_orderby, encoding_scheme, 
pctpagessaved, last_regen_time, secpolicyid, protectiongranularity, 
auditpolicyid, auditexceptionenabled, oncommit, logged, onrollback, 
lastused, control, extended_row_size, pctextendedrows, remarks, 
packed_desc, view_desc, rel_desc, check_desc, trig_desc, remote_desc, 
ast_desc, statistics_profile, controls_desc, auditexception_desc 
from sysibm.systables 

;

-- View: SYSCAT.TABAUTH
CREATE VIEW SYSCAT.TABAUTH AS create or replace view syscat.tabauth 
(grantor, grantortype, grantee, granteetype, tabschema, tabname, 
controlauth, alterauth, deleteauth, indexauth, insertauth, 
refauth, selectauth, updateauth) 
as select 
grantor, grantortype, grantee, granteetype, tcreator, ttname, 
controlauth, alterauth, deleteauth, indexauth, insertauth, 
refauth, selectauth, updateauth 
from sysibm.systabauth 

;

-- View: SYSCAT.TABCONST
CREATE VIEW SYSCAT.TABCONST AS create or replace view syscat.tabconst 
(constname, tabschema, tabname, owner, ownertype, type, 
enforced, trusted, checkexistingdata, enablequeryopt, definer, 
periodname, periodpolicy, remarks) 
as select 
name, tbcreator, tbname, definer, definertype, constraintyp, 
enforced, trusted, checkexistingdata, enablequeryopt, definer, 
periodname, periodpolicy, remarks 
from sysibm.systabconst
;

-- View: SYSCAT.TABDEP
CREATE VIEW SYSCAT.TABDEP AS create or replace view syscat.tabdep 
(tabschema, tabname, dtype, owner, ownertype, btype, bschema, 
bmodulename, bname, bmoduleid, tabauth, varauth, definer) 
as select 
dcreator, dname, dtype, vcauthid, vcauthidtype, btype, bcreator, 
m.modulename, bname, bmoduleid, 
case when btype <> 'v' then tabauth else SMALLINT(0) end, 
case when btype = 'v' then tabauth else SMALLINT(0) end, vcauthid 
from sysibm.sysviewdep left outer join sysibm.sysmodules m on 
bmoduleid=m.moduleid
;

-- View: SYSCAT.TABDETACHEDDEP
CREATE VIEW SYSCAT.TABDETACHEDDEP AS create or replace view syscat.tabdetacheddep 
(tabschema, tabname, deptabschema, deptabname) 
as select 
bschema, bname, dschema, dname 
from sysibm.sysdependencies 
where btype = 'L'
;

-- View: SYSCAT.TABLES
CREATE VIEW SYSCAT.TABLES AS create or replace view syscat.tables 
(tabschema, tabname, owner, ownertype, type, status, 
base_tabschema, base_tabname, rowtypeschema, rowtypename, 
create_time, alter_time, invalidate_time, stats_time, colcount, 
tableid, tbspaceid, card, npages, mpages, fpages, 
npartitions, nfiles, tablesize, 
overflow, tbspace, 
index_tbspace, long_tbspace, parents, children, selfrefs, 
keycolumns, keyindexid, keyunique, checkcount, 
datacapture, const_checked, pmap_id, partition_mode, 
log_attribute, pctfree, append_mode, refresh, 
refresh_time, locksize, volatile, row_format, 
property, statistics_profile, compression, rowcompmode, 
access_mode, clustered, active_blocks, droprule, maxfreespacesearch, 
avgcompressedrowsize, avgrowcompressionratio, avgrowsize, 
pctrowscompressed, logindexbuild, codepage, collationschema, 
collationname, collationschema_orderby, collationname_orderby, 
encoding_scheme, 
pctpagessaved, last_regen_time, secpolicyid, 
protectiongranularity, auditpolicyid, auditpolicyname, auditexceptionenabled, 
definer, oncommit, logged, onrollback, lastused, control, temporaltype, 
tableorg, extended_row_size, pctextendedrows, remarks) 
as select 
creator, name, definer, definertype, type, status, 
base_schema, base_name, rowtypeschema, rowtypename, 
ctime, alter_time, invalidate_time, stats_time, colcount, 
fid, tid, card, npages, mpages, fpages, 
case 
when type = 'T' and substr(property,22,1) = 'Y' then mpages 
else -1 
end, 
case 
when type = 'T' and ((substr(property,22,1) = 'Y') or 
(substr(property,24,1) = 'Y')) then npages 
else -1 
end, 
case 
when type = 'T' and ((substr(property,22,1) = 'Y') or 
(substr(property,24,1) = 'Y')) then fpages 
else -1 
end, 
overflow, tbspace, 
index_tbspace, long_tbspace, parents, children, selfrefs, 
keycolumns, keyobid, keyunique, checkcount, 
data_capture, const_checked, pmap_id, partition_mode, 
cast('0' as char(1)), pctfree, append_mode, refresh, 
refresh_time, locksize, volatile, cast('N' as char(1)), 
property, statistics_profile, compression, rowcompmode, 
access_mode, clustered, active_blocks, droprule, maxfreespacesearch, 
avgcompressedrowsize, avgrowcompressionratio, avgrowsize, 
pctrowscompressed, 
cast (case when logindexbuild='N' then 'OFF' 
when logindexbuild='Y' then 'ON' else NULL end as varchar(3)), 
codepage, 
coalesce((select c1.collationschema from sysibm.syscollations c1 
where t.collationid = c1.collationid), 'SYSIBM'), 
coalesce((select c1.collationname from sysibm.syscollations c1 
where t.collationid = c1.collationid), 
syscat.collationname(t.collationid)), 
coalesce((select c2.collationschema from sysibm.syscollations c2 
where t.collationid_orderby = c2.collationid), 'SYSIBM'), 
coalesce((select c2.collationname from sysibm.syscollations c2 
where t.collationid_orderby = c2.collationid), 
syscat.collationname(t.collationid_orderby)), 
encoding_scheme, pctpagessaved, last_regen_time, 
secpolicyid, protectiongranularity, auditpolicyid, 
case when t.auditpolicyid is null then null 
else (select auditpolicyname from sysibm.sysauditpolicies aud 
where t.auditpolicyid = aud.auditpolicyid) 
end, 
auditexceptionenabled, definer, oncommit, logged, onrollback, lastused, 
control, 
case 
when t.type <> 'T' OR (t.type='T' and t.definertype='S') then 
cast ('N' as char(1)) 
when EXISTS(select 1 from sysibm.sysperiods p where p.tabname = t.name 
and p.tabschema = t.creator and p.periodtype=2 ) and 
EXISTS(select 1 from sysibm.sysperiods p where p.tabname = t.name 
and p.tabschema = t.creator and p.periodtype=1 and 
p.historyfid <> 0 ) 
then  cast('B' as char(1)) 
when EXISTS(select 1 from sysibm.sysperiods p where p.tabname = t.name 
and p.tabschema = t.creator and p.periodtype=1 and 
p.historyfid <> 0 ) 
then cast('S' as char(1)) 
when EXISTS(select 1 from sysibm.sysperiods p where p.tabname = t.name 
and p.tabschema = t.creator and p.periodtype=2 ) 
then cast('A' as char(1)) 
else cast('N' as char(1)) 
end, 
case 
when type in ('A', 'N', 'V', 'W') then cast ('N' as char(1)) 
when substr(property,20,1) = 'Y' then cast ('C' as char(1)) 
else cast ('R' as char(1)) 
end, 
extended_row_size, pctextendedrows, 
remarks 
from sysibm.systables t
;

-- View: SYSCAT.TABLESPACES
CREATE VIEW SYSCAT.TABLESPACES AS create or replace view syscat.tablespaces 
(tbspace, owner, ownertype, create_time, tbspaceid, 
tbspacetype, datatype, extentsize, prefetchsize, overhead, 
transferrate, writeoverhead, writetransferrate, pagesize, dbpgname, 
bufferpoolid, drop_recovery, ngname, definer, datatag, sgname, 
sgid, effectiveprefetchsize, cachingtier, remarks) 
as select 
a.tbspace, a.definer, a.definertype, a.create_time, a.tbspaceid, 
case a.tbspacetype when 'F' then cast('D' as char(1)) else a.tbspacetype end, 
a.datatype, a.extentsize, a.prefetchsize, a.overhead, 
a.transferrate, a.writeoverhead, a.writetransferrate, a.pagesize, a.ngname, 
a.bufferpoolid, a.drop_recovery, a.ngname, a.definer, a.datatag, b.sgname, 
a.sgid, a.effectiveprefetchsize, 
cast( case 
when a.cachingtier = 0 then 'DISABLED' 
when a.cachingtier = -1 then 'INHERIT' 
else 'ENABLED' 
end as varchar(8)), 
a.remarks 
from sysibm.systablespaces a 
left outer join sysibm.sysstogroups b 
on a.sgid = b.sgid
;

-- View: SYSCAT.TABOPTIONS
CREATE VIEW SYSCAT.TABOPTIONS AS create or replace view syscat.taboptions 
(tabschema, tabname, option, setting) 
as select 
tabschema, tabname, option, setting 
from sysibm.systaboptions
;

-- View: SYSCAT.TBSPACEAUTH
CREATE VIEW SYSCAT.TBSPACEAUTH AS create or replace view syscat.tbspaceauth 
(grantor, grantortype, grantee, granteetype, tbspace, useauth) 
as select 
grantor, grantortype, grantee, granteetype, tbspace, useauth 
from sysibm.systbspaceauth
;

-- View: SYSCAT.THRESHOLDS
CREATE VIEW SYSCAT.THRESHOLDS AS create or replace view syscat.thresholds 
(thresholdname, thresholdid, origin, thresholdclass, thresholdpredicate, 
thresholdpredicateid, domain, domainid, enforcement, queuing, maxvalue, 
datataglist, queuesize, overflowpercent, collectactdata, collectactpartition, 
execution, 
remapscid, violationrecordlogged, checkinterval, enabled, create_time, 
alter_time, remarks) 
as select 
t.thresholdname, t.thresholdid, t.origin, t.thresholdclass, 
t.thresholdpredicate, t.thresholdpredicateid, t.domain, t.domainid, 
t.enforcement, t.queuing, t.maxvalue, 
cast (case when t.thresholdpredicateid = 170 or t.thresholdpredicateid = 180 
then 
SYSIBMINTERNAL.WLM_FORMAT_DATA_TAG_LIST(t.maxvalue) 
else 
NULL 
end as VARCHAR(256)), 
t.queuesize, t.overflowpercent, t.collectactdata, 
t.collectactpartition, t.execution, t.remapscid, t.violationrecordlogged, 
t.checkinterval, t.enabled, t.create_time, t.alter_time, c.remarks 
from sysibm.systhresholds t 
left outer join sysibm.syscomments c 
on t.thresholdid = c.objectid and c.objecttype = 'f'
;

-- View: SYSCAT.TRANSFORMS
CREATE VIEW SYSCAT.TRANSFORMS AS create or replace view syscat.transforms 
(typeid, typeschema, typename, groupname, funcid, 
funcschema, funcname, specificname, transformtype, 
format, maxlength, origin, remarks) 
as select 
d.typeid, d.schema, d.name, t.groupname, f.routine_id, 
f.routineschema, f.routinename, f.specificname, cast('FROM SQL' as 
varchar(8)), 
t.fromsql_format, t.fromsql_length, t.origin, t.remarks 
from sysibm.systransforms as t, 
sysibm.sysdatatypes as d, 
sysibm.sysroutines as f 
where t.typeid = d.typeid 
and t.fromsql_funcid = f.routine_id 
and f.routinetype in ('F', 'M') 
and f.routineschema not in ('SYSIBMINTERNAL') 
union all 
select d.typeid, d.schema, d.name, t.groupname, 
f.routine_id, f.routineschema, f.routinename, f.specificname, 
cast('TO SQL' as varchar(8)), t.tosql_format, cast(NULL as integer), 
t.origin, t.remarks 
from sysibm.systransforms as t, 
sysibm.sysdatatypes as d, 
sysibm.sysroutines as f 
where t.typeid = d.typeid 
and t.tosql_funcid = f.routine_id 
and f.routinetype in ('F', 'M') 
and f.routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSCAT.TRIGDEP
CREATE VIEW SYSCAT.TRIGDEP AS create or replace view syscat.trigdep 
(trigschema, trigname, btype, bschema, bmodulename, bname, bmoduleid, tabauth) 
as select 
dschema, dname, btype, bschema, m.modulename, bname, bmoduleid, tabauth 
from sysibm.sysdependencies 
left outer join sysibm.sysmodules m on bmoduleid=m.moduleid 
where dtype = 'B'
;

-- View: SYSCAT.TRIGGERS
CREATE VIEW SYSCAT.TRIGGERS AS create or replace view syscat.triggers 
(trigschema, trigname, owner, ownertype, tabschema, tabname, 
trigtime, trigevent, eventupdate, eventdelete, eventinsert, granularity, 
valid, 
create_time, qualifier, func_path, text, 
last_regen_time, collationschema, 
collationname, collationschema_orderby, collationname_orderby, 
definer, secure, alter_time, debug_mode, 
enabled, envstringunits, remarks, lib_id, precompile_options, compile_options) 
as select 
schema, name, definer, definertype, tbcreator, tbname, 
trigtime, cast (case trigevent 
when '1' then 'M' 
when '2' then 'M' 
when '3' then 'M' 
when '4' then 'M' 
else trigevent end as char(1)), 
cast (case trigevent when '3' then 'N' 
when 'I' then 'N' 
when 'D' then 'N' 
else 'Y' end as char(1)), 
cast (case trigevent when '2' then 'N' 
when 'U' then 'N' 
when 'I' then 'N' 
else 'Y' end as char(1)), 
cast (case trigevent when '1' then 'N' 
when 'U' then 'N' 
when 'D' then 'N' 
else 'Y' end as char(1)), 
granularity, valid, 
create_time, qualifier, func_path, text, 
last_regen_time, 
coalesce(c1.collationschema, 'SYSIBM'), 
coalesce(c1.collationname, syscat.collationname(t.collationid)), 
coalesce(c2.collationschema, 'SYSIBM'), 
coalesce(c2.collationname, syscat.collationname(t.collationid_orderby)), 
definer, secure, alter_time, 
cast (case 
when t.debug_mode = ' ' then 'DISALLOW' 
when t.debug_mode = 'Y' then 'ALLOW' 
when t.debug_mode = 'N' then 'DISABLE' 
else t.debug_mode end as varchar(8)), 
enabled, 
cast(case 
when t.stringunits = 'S' then 'SYSTEM' 
when t.stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)), 
remarks, t.lib_id, c.precompile_options, c.compile_options 
from (sysibm.systriggers t 
left outer join sysibm.syscodeproperties as c 
on c.object_type = 'B' and 
t.lib_id = c.object_id and 
t.lib_id = c.lib_id) 
left outer join sysibm.syscollations as c1 
on t.collationid = c1.collationid 
left outer join sysibm.syscollations as c2 
on t.collationid_orderby = c2.collationid
;

-- View: SYSCAT.TYPEMAPPINGS
CREATE VIEW SYSCAT.TYPEMAPPINGS AS create or replace view syscat.typemappings 
(type_mapping, mappingdirection, 
typeschema, typename, typeid, sourcetypeid, owner, ownertype, 
length, scale, lower_len, upper_len, 
lower_scale, upper_scale, s_opr_p, bit_data, 
wrapname, servername, servertype, serverversion, 
remote_typeschema, remote_typename, remote_meta_type, 
remote_lower_len, remote_upper_len, remote_lower_scale, remote_upper_scale, 
remote_s_opr_p, remote_bit_data, user_defined, create_time, definer, remarks) 
as select 
type_mapping, mappingdirection, 
typeschema, typename, typeid, sourcetypeid, definer, definertype, 
upper_len, upper_scale, lower_len, upper_len, 
lower_scale, upper_scale, s_opr_p, bit_data, 
wrapname, servername, servertype, serverversion, 
remote_typeschema, remote_typename, remote_meta_type, 
remote_lower_len, remote_upper_len, remote_lower_scale, remote_upper_scale, 
remote_s_opr_p, remote_bit_data, user_defined, create_time, definer, remarks 
from sysibm.systypemappings
;

-- View: SYSCAT.USAGELISTS
CREATE VIEW SYSCAT.USAGELISTS AS create or replace view syscat.usagelists 
(usagelistschema, usagelistname, usagelistid, objectschema, 
objectname, objecttype, status, maxlistsize, whenfull, 
autostart, activeduration, remarks) 
as select 
a.usagelistschema, a.usagelistname, a.usagelistid, a.objectschema, 
a.objectname, a.objecttype, a.status, a.maxlistsize, a.whenfull, 
a.autostart, a.activeduration, b.remarks 
from sysibm.sysusagelists as a left outer join sysibm.syscomments as b 
on a.usagelistid = b.objectid and b.objecttype = '3' 

;

-- View: SYSCAT.USEROPTIONS
CREATE VIEW SYSCAT.USEROPTIONS AS create or replace view syscat.useroptions 
(authid, authidtype, servername, option, setting) 
as select 
authid, authidtype, servername, option, 
case 
when option = 'REMOTE_PASSWORD' then '********' 
else setting 
end 
from sysibm.sysuseroptions
;

-- View: SYSCAT.VARIABLEAUTH
CREATE VIEW SYSCAT.VARIABLEAUTH AS create or replace view syscat.variableauth 
(grantor, grantortype, grantee, granteetype, 
varschema, varname, varid, readauth, writeauth) 
as select 
a.grantor, a.grantortype, a.grantee, a.granteetype, 
b.varschema, b.varname,  a.varid, a.readauth, a.writeauth 
from 
sysibm.sysvariableauth as a, sysibm.sysvariables as b 
where a.varid = b.varid and 
not (a.grantee LIKE 'SYSROLE%' and a.granteetype='R') 

;

-- View: SYSCAT.VARIABLEDEP
CREATE VIEW SYSCAT.VARIABLEDEP AS create or replace view syscat.variabledep 
(varschema, varmodulename, varname, varmoduleid, 
btype, bschema, bmodulename, bname, bmoduleid, tabauth) 
as select 
dschema, md.modulename, dname, dmoduleid, 
btype, bschema, mb.modulename, bname, bmoduleid, tabauth 
from 
sysibm.sysdependencies 
left outer join sysibm.sysmodules md on dmoduleid=md.moduleid 
left outer join sysibm.sysmodules mb on bmoduleid=mb.moduleid 
where dtype = 'v'
;

-- View: SYSCAT.VARIABLES
CREATE VIEW SYSCAT.VARIABLES AS create or replace view  syscat.variables 
(varschema, varmodulename, varname, varmoduleid, varid, 
owner, ownertype, create_time, last_regen_time, valid, published, 
typeschema, typemodulename, typename, typemoduleid, length, scale, 
typestringunits, stringunitslength, codepage, 
collationschema, collationname, collationschema_orderby, 
collationname_orderby, 
scope, default, qualifier, func_path, envstringunits, remarks, readonly, 
nulls) 
as select 
v.varschema, m.modulename, v.varname, v.varmoduleid, v.varid, 
v.owner, v.ownertype, v.create_time, v.last_regen_time, 
v.valid, v.published, d.schema, m1.modulename, d.name, d.typemoduleid, 
v.length, 
CASE WHEN (v.codepage=1208 or v.codepage=1200) and v.scale<>0 THEN CAST(0 as 
SMALLINT) 
ELSE v.scale END, 
CASE WHEN v.codepage=1208 and v.scale=0 THEN CAST('OCTETS' as VARCHAR(11)) 
WHEN v.codepage=1208 and v.scale=4 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
WHEN v.codepage=1200 and v.scale=0 THEN CAST('CODEUNITS16' as 
VARCHAR(11)) 
WHEN v.codepage=1200 and v.scale=2 THEN CAST('CODEUNITS32' as 
VARCHAR(11)) 
ELSE CAST(NULL AS VARCHAR(11)) END, 
CASE WHEN (v.codepage=1208 or v.codepage=1200) and v.scale=0 THEN v.length 
WHEN (v.codepage=1208 or v.codepage=1200) and v.scale<>0 THEN 
CAST(v.length/v.scale as INTEGER) 
ELSE CAST(NULL AS INTEGER) END, 
v.codepage, coalesce(c1.collationschema, 'SYSIBM'), 
coalesce(c1.collationname, syscat.collationname(v.collationid)), 
coalesce(c2.collationschema, 'SYSIBM'), 
coalesce(c2.collationname, syscat.collationname(v.collationid_orderby)), 
v.scope, v.default, v.qualifier, v.func_path, 
cast(case 
when v.stringunits = 'S' then 'SYSTEM' 
when v.stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)), 
c.remarks, v.readonly, v.nulls 
from 
sysibm.sysvariables as v 
left outer join sysibm.sysdatatypes as d on v.typeid = d.typeid 
left outer join sysibm.sysmodules m1 on d.typemoduleid = m1.moduleid 
left outer join sysibm.sysmodules m on v.varmoduleid = m.moduleid 
left outer join sysibm.syscomments as c 
on v.varid = c.objectid and c.objecttype = 'v' 
left outer join sysibm.syscollations as c1 
on v.collationid = c1.collationid 
left outer join sysibm.syscollations as c2 
on v.collationid_orderby = c2.collationid 
where NOT(d.schema = 'SYSPROC' AND d.name = 'DB2SQLSTATE') OR 
(d.schema IS NULL OR d.name IS NULL)
;

-- View: SYSCAT.VIEWDEP
CREATE VIEW SYSCAT.VIEWDEP AS create or replace view syscat.viewdep 
(viewschema, viewname, dtype, owner, btype, bschema, bmodulename, bname, 
bmoduleid, 
tabauth, definer) 
as select 
dcreator, dname, dtype, vcauthid, btype, bcreator, m.modulename, bname, 
bmoduleid, 
case when btype <> 'v' then tabauth else SMALLINT(0) end, vcauthid 
from sysibm.sysviewdep left outer join sysibm.sysmodules m on 
bmoduleid=m.moduleid
;

-- View: SYSCAT.VIEWS
CREATE VIEW SYSCAT.VIEWS AS create or replace view syscat.views 
(viewschema, viewname, owner, ownertype, seqno, viewcheck, readonly, 
valid, qualifier, func_path, text, definer, envstringunits) 
as select 
creator, name, definer, definertype, 1, check, readonly, 
valid, qualifier, func_path, text, definer, 
cast(case 
when stringunits = 'S' then 'SYSTEM' 
when stringunits = '4' then 'CODEUNITS32' 
else ' ' end as varchar(11)) 
from sysibm.sysviews
;

-- View: SYSCAT.WORKACTIONS
CREATE VIEW SYSCAT.WORKACTIONS AS create or replace view syscat.workactions 
(actionname, actionid, actionsetname, actionsetid, workclassname, 
workclassid, create_time, alter_time, enabled, actiontype, 
refobjectid, refobjecttype, sectionactualsoptions) 
as select 
a.actionname, a.actionid, b.actionsetname, a.actionsetid, c.workclassname, 
a.workclassid, a.create_time, a.alter_time, a.enabled, a.actiontype, 
a.refobjectid, 
cast(case when a.actiontype = 't' then 'THRESHOLD' 
when a.actiontype in ('m','n') then 'SERVICE CLASS' 
else null end as varchar(30)), a.sectionactualsoptions 
from sysibm.sysworkactions as a left outer join sysibm.sysworkactionsets as b 
on a.actionsetid = b.actionsetid 
left outer join sysibm.sysworkclasses as c 
on a.workclassid = c.workclassid 
;

-- View: SYSCAT.WORKACTIONSETS
CREATE VIEW SYSCAT.WORKACTIONSETS AS create or replace view syscat.workactionsets 
(actionsetname, actionsetid, workclasssetname, workclasssetid, create_time, 
alter_time, enabled, objecttype, objectname, objectid, remarks) 
as select 
a.actionsetname, a.actionsetid, b.workclasssetname, a.workclasssetid, 
a.create_time, a.alter_time, a.enabled, a.objecttype, 
case when a.objecttype = 'b' then c.serviceclassname 
when a.objecttype = 'w' then e.workloadname 
else null end, 
a.objectid, d.remarks 
from sysibm.sysworkactionsets as a left outer join sysibm.sysserviceclasses as c 
on c.serviceclassid = a.objectid 
left outer join sysibm.sysworkloads as e 
on e.workloadid = a.objectid 
left outer join sysibm.sysworkclasssets as b 
on a.workclasssetid = b.workclasssetid 
left outer join sysibm.syscomments as d 
on d.objectid = a.actionsetid and d.objecttype = 'a'
;

-- View: SYSCAT.WORKCLASSATTRIBUTES
CREATE VIEW SYSCAT.WORKCLASSATTRIBUTES AS CREATE OR REPLACE view syscat.workclassattributes 
(workclassname, workclasssetname, workclassid, workclasssetid, type, value1, 
value2, value3) 
as select 
b.workclassname, c.workclasssetname, a.workclassid, c.workclasssetid, 
cast (case a.typeid 
when 1 then 'WORK TYPE' 
when 2 then 'TIMERONCOST' 
when 3 then 'CARDINALITY' 
when 4 then 'DATA TAG' 
when 5 then 'ROUTINE SCHEMA' 
when 6 then 'RUNTIME' 
else 'UNKNOWN' end as varchar(30)), 
a.value1, a.value2, a.value3 
from sysibm.sysworkclassattributes as a left outer join sysibm.sysworkclasses 
as b on a.workclassid = b.workclassid 
left outer join sysibm.sysworkclasssets as c on 
b.workclasssetid = c.workclasssetid
;

-- View: SYSCAT.WORKCLASSES
CREATE VIEW SYSCAT.WORKCLASSES AS CREATE OR REPLACE view syscat.workclasses 
(workclassname, workclasssetname, workclassid, workclasssetid, create_time, 
alter_time, evaluationorder) 
as select 
a.workclassname, b.workclasssetname, a.workclassid, a.workclasssetid, 
a.create_time, a.alter_time, a.evaluationorder 
from sysibm.sysworkclasses as a left outer join sysibm.sysworkclasssets as b 
on a.workclasssetid = b.workclasssetid
;

-- View: SYSCAT.WORKCLASSSETS
CREATE VIEW SYSCAT.WORKCLASSSETS AS CREATE OR REPLACE view syscat.workclasssets 
(workclasssetname, workclasssetid, create_time, alter_time, remarks) 
as select 
a.workclasssetname, a.workclasssetid, a.create_time, a.alter_time, b.remarks 
from sysibm.sysworkclasssets as a left outer join sysibm.syscomments as b 
on b.objectid = a.workclasssetid and b.objecttype = 'e'
;

-- View: SYSCAT.WORKLOADAUTH
CREATE VIEW SYSCAT.WORKLOADAUTH AS CREATE OR REPLACE view syscat.workloadauth 
(workloadid, workloadname, grantor, grantortype, grantee, granteetype, 
usageauth) 
as select 
w.workloadid, w.workloadname, a.grantor, a.grantortype, a.grantee, 
a.granteetype, a.usageauth 
from sysibm.sysworkloads w, sysibm.sysworkloadauth a 
where w.workloadid = a.workloadid
;

-- View: SYSCAT.WORKLOADCONNATTR
CREATE VIEW SYSCAT.WORKLOADCONNATTR AS CREATE OR REPLACE view syscat.workloadconnattr 
(workloadid, workloadname, connattrtype, connattrvalue) 
as select 
w.workloadid, w.workloadname, 
cast (case c.connattrid 
when 1 then 'APPLNAME' 
when 2 then 'SYSTEM_USER' 
when 3 then 'SESSION_USER' 
when 4 then 'SESSION_USER GROUP' 
when 5 then 'SESSION_USER ROLE' 
when 6 then 'CURRENT CLIENT_USERID' 
when 7 then 'CURRENT CLIENT_APPLNAME' 
when 8 then 'CURRENT CLIENT_WRKSTNNAME' 
when 9 then 'CURRENT CLIENT_ACCTNG' 
when 10 then 'ADDRESS' 
when 11 then 'CURRENT TENANT' 
else 'UNKNOWN' 
end as varchar(30)), 
c.connattrvalue 
from sysibm.sysworkloads w, sysibm.sysworkloadconnattr c 
where w.workloadid = c.workloadid
;

-- View: SYSCAT.WORKLOADS
CREATE VIEW SYSCAT.WORKLOADS AS create or replace view syscat.workloads 
(workloadid, workloadname, evaluationorder, create_time, alter_time, 
enabled, allowaccess, maxdegree, serviceclassname, parentserviceclassname, 
collectaggactdata, collectactdata, collectactpartition, 
collectdeadlock, collectlocktimeout, collectlockwait, lockwaitvalue, 
collectactmetrics, collectuowdataoptions, collectuowdata, externalname, 
sectionactualsoptions, collectagguowdata, priority, remarks) 
as select 
w.workloadid, w.workloadname, w.evaluationorder, w.create_time, 
w.alter_time, w.enabled, w.allowaccess, w.maxdegree, s1.serviceclassname, 
s2.serviceclassname, w.collectaggactdata, w.collectactdata, 
w.collectactpartition, w.collectdeadlock, w.collectlocktimeout, 
w.collectlockwait, w.lockwaitvalue, w.collectactmetrics, 
w.collectuowdataoptions, 
CAST(case when substring(w.collectuowdataoptions,2,1,OCTETS)='Y' then 'P' 
else substring(w.collectuowdataoptions,1,1,OCTETS) 
end as CHAR(1)), 
w.externalname, w.sectionactualsoptions, w.collectagguowdata, 
CAST(case SYSIBMINTERNAL.WLM_GET_WORKLOAD_PRIORITY(w.WORKLOAD_DESC) when 0 then 
'CRITICAL' when 1 then 'HIGH' when 3 then 'LOW' else 'MEDIUM' 
end as CHAR(8)), 
c.remarks 
from sysibm.sysworkloads w left outer join sysibm.syscomments c 
on w.workloadid = c.objectid and c.objecttype = 'w' 
inner join sysibm.sysserviceclasses s1 
on s1.serviceclassid = w.serviceclassid 
left outer join sysibm.sysserviceclasses s2 
on s1.parentid = s2.serviceclassid
;

-- View: SYSCAT.WRAPOPTIONS
CREATE VIEW SYSCAT.WRAPOPTIONS AS create or replace view syscat.wrapoptions 
(wrapname, option, setting) 
as select 
wrapname, option, setting 
from sysibm.syswrapoptions
;

-- View: SYSCAT.WRAPPERS
CREATE VIEW SYSCAT.WRAPPERS AS create or replace view syscat.wrappers 
(wrapname, wraptype, wrapversion, library, remarks) 
as select 
wrapname, wraptype, wrapversion, library, remarks 
from sysibm.syswrappers
;

-- View: SYSCAT.XDBMAPGRAPHS
CREATE VIEW SYSCAT.XDBMAPGRAPHS AS create or replace view syscat.xdbmapgraphs 
(objectid, objectschema, objectname, schemagraphid, 
namespace, rootelement) 
as select 
o.xsrobjectid, o.xsrobjectschema, o.xsrobjectname, m.schemagraphid, 
(select substr(sysibm.xmlbit2char(string), 1, 
length(sysibm.xmlbit2char(string))-1) from sysibm.sysxmlstrings 
where m.namespaceid=stringid), 
(select substr(sysibm.xmlbit2char(string), 1, 
length(sysibm.xmlbit2char(string))-1) from sysibm.sysxmlstrings 
where m.rootelementid=stringid) 
from sysibm.sysxdbmapgraphs m, 
sysibm.sysxsrobjects o 
where o.xsrobjectid=m.xsrobjectid
;

-- View: SYSCAT.XDBMAPSHREDTREES
CREATE VIEW SYSCAT.XDBMAPSHREDTREES AS create or replace view syscat.xdbmapshredtrees 
(objectid, objectschema, objectname, schemagraphid, 
shredtreeid, mappingdescription) 
as select 
o.xsrobjectid, o.xsrobjectschema, o.xsrobjectname, m.schemagraphid, 
m.shredtreeid, m.mappingdescription 
from sysibm.sysxdbmapshredtrees m, 
sysibm.sysxsrobjects o 
where o.xsrobjectid=m.xsrobjectid
;

-- View: SYSCAT.XMLSTRINGS
CREATE VIEW SYSCAT.XMLSTRINGS AS create or replace view syscat.xmlstrings 
(stringid, string, string_utf8) 
as select 
stringid, 
substr(sysibm.xmlbit2char(string), 1, length(sysibm.xmlbit2char(string)) - 1), 
substr(string, 1, length(string) - 1) 
from sysibm.sysxmlstrings
;

-- View: SYSCAT.XSROBJECTAUTH
CREATE VIEW SYSCAT.XSROBJECTAUTH AS create or replace view syscat.xsrobjectauth 
(grantor, grantortype, grantee, granteetype, objectid, usageauth) 
as select 
grantor, grantortype, grantee, granteetype, xsrobjectid, usageauth 
from sysibm.sysxsrobjectauth
;

-- View: SYSCAT.XSROBJECTCOMPONENTS
CREATE VIEW SYSCAT.XSROBJECTCOMPONENTS AS create or replace view syscat.xsrobjectcomponents 
(objectid, objectschema, objectname,componentid,targetnamespace, 
schemalocation, component, create_time, status) 
as select 
o.xsrobjectid, o.xsrobjectschema, o.xsrobjectname, c.xsrcomponentid, 
(select substr(sysibm.xmlbit2char(string), 1, 
length(sysibm.xmlbit2char(string))-1) from sysibm.sysxmlstrings 
where c.targetnamespaceid=stringid), 
(select substr(sysibm.xmlbit2char(string), 1, 
length(sysibm.xmlbit2char(string))-1) from sysibm.sysxmlstrings 
where c.schemalocationid=stringid), 
c.component, c.create_time, c.status 
from sysibm.sysxsrobjects o, 
sysibm.sysxsrobjectcomponents c, 
sysibm.sysxsrobjecthierarchies h 
where o.xsrobjectid=h.xsrobjectid 
and c.xsrcomponentid=h.xsrcomponentid 
and (h.htype='P' or h.htype='D')
;

-- View: SYSCAT.XSROBJECTDEP
CREATE VIEW SYSCAT.XSROBJECTDEP AS create or replace view syscat.xsrobjectdep 
(objectid, objectschema, objectname, btype, 
bschema, bmodulename, bname, bmoduleid, tabauth) 
as select 
x.xsrobjectid, d.dschema, d.dname, d.btype, 
d.bschema, m.modulename, d.bname, d.bmoduleid, d.tabauth 
from sysibm.sysdependencies d 
left outer join sysibm.sysmodules m on d.bmoduleid=m.moduleid, 
sysibm.sysxsrobjects x 
where d.dtype = 'Z' and 
x.xsrobjectname=d.dname and x.xsrobjectschema=d.dschema
;

-- View: SYSCAT.XSROBJECTDETAILS
CREATE VIEW SYSCAT.XSROBJECTDETAILS AS create or replace view syscat.xsrobjectdetails 
(objectid, objectschema, objectname, grammar, properties) 
as select 
o.xsrobjectid, o.xsrobjectschema, o.xsrobjectname, 
o.grammar, o.properties 
from sysibm.sysxsrobjects as o 
where o.objecttype='S'
;

-- View: SYSCAT.XSROBJECTHIERARCHIES
CREATE VIEW SYSCAT.XSROBJECTHIERARCHIES AS create or replace view syscat.xsrobjecthierarchies 
(objectid, componentid, htype, targetnamespace, schemalocation) 
as select 
o.xsrobjectid, o.xsrcomponentid, o.htype, 
(select substr(sysibm.xmlbit2char(string), 1, 
length(sysibm.xmlbit2char(string))-1) from sysibm.sysxmlstrings 
where o.targetnamespaceid=stringid), 
(select substr(sysibm.xmlbit2char(string), 1, 
length(sysibm.xmlbit2char(string))-1) from sysibm.sysxmlstrings 
where o.schemalocationid=stringid) 
from sysibm.sysxsrobjecthierarchies o
;

-- View: SYSCAT.XSROBJECTS
CREATE VIEW SYSCAT.XSROBJECTS AS create or replace view syscat.xsrobjects 
(objectid, objectschema, objectname, targetnamespace, 
schemalocation, objectinfo, objecttype, owner, ownertype, 
create_time, alter_time, status, decomposition, remarks) 
as select 
o.xsrobjectid, o.xsrobjectschema, o.xsrobjectname, 
(select substr(sysibm.xmlbit2char(string), 1, 
length(sysibm.xmlbit2char(string))-1) from sysibm.sysxmlstrings 
where o.targetnamespaceid=stringid), 
(select substr(sysibm.xmlbit2char(string), 1, 
length(sysibm.xmlbit2char(string))-1) from sysibm.sysxmlstrings 
where o.schemalocationid=stringid), 
o.objectinfo, o.objecttype, o.owner, o.ownertype, o.create_time, 
o.alter_time, o.status, o.decomposition, c.remarks 
from sysibm.sysxsrobjects as o left outer join sysibm.syscomments as c 
on o.xsrobjectid=c.objectid and c.objecttype='Z'
;

-- Schema: SYSIBM
CREATE SCHEMA SYSIBM;

-- View: SYSIBM.CHECK_CONSTRAINTS
CREATE VIEW SYSIBM.CHECK_CONSTRAINTS AS CREATE OR REPLACE VIEW SYSIBM.CHECK_CONSTRAINTS 
(CONSTRAINT_CATALOG, CONSTRAINT_SCHEMA, CONSTRAINT_NAME, CHECK_CLAUSE) 
AS SELECT 
CAST(CURRENT SERVER AS VARCHAR(128)), TBCREATOR, 
CAST(NAME AS VARCHAR(128)), TEXT 
FROM SYSIBM.SYSCHECKS 
WHERE TYPE='C' 
UNION ALL 
SELECT CAST(CURRENT SERVER AS VARCHAR(128)), TBCREATOR, 
CAST(CONCAT(RTRIM(CONCAT(CHAR(CTIME), CHAR(FID) ) ), 
RTRIM(CHAR(COLNO)) ) AS VARCHAR(128) ), 
CAST(CONCAT(CONCAT('CHECK (', C.NAME), ' IS NOT NULL)') AS CLOB(64K) ) 
FROM SYSIBM.SYSCOLUMNS C, SYSIBM.SYSTABLES T 
WHERE C.TBCREATOR = T.CREATOR AND C.TBNAME = T.NAME AND TYPE IN('U', 'T') 
AND NULLS ='N'
;

-- View: SYSIBM.COLUMNS
CREATE VIEW SYSIBM.COLUMNS AS CREATE OR REPLACE VIEW SYSIBM.COLUMNS 
( TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, 
COLUMN_DEFAULT, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
CHARACTER_OCTET_LENGTH, NUMERIC_PRECISION,  NUMERIC_PRECISION_RADIX, 
NUMERIC_SCALE, DATETIME_PRECISION, INTERVAL_TYPE, INTERVAL_PRECISION, 
CHARACTER_SET_CATALOG, CHARACTER_SET_SCHEMA, CHARACTER_SET_NAME, 
COLLATION_CATALOG, COLLATION_SCHEMA, COLLATION_NAME, DOMAIN_CATALOG, 
DOMAIN_SCHEMA, DOMAIN_NAME, UDT_CATALOG, UDT_SCHEMA, UDT_NAME, 
SCOPE_CATALOG, SCOPE_SCHEMA, SCOPE_NAME, MAXIMUM_CARDINALITY, 
DTD_IDENTIFIER, IS_SELF_REFERENCING ) 
AS SELECT 
CAST(CURRENT SERVER AS VARCHAR(128)), C.TBCREATOR, C.TBNAME, C.NAME, 
CAST(C.COLNO+1  AS INTEGER), CAST(C.DEFAULT AS VARCHAR(2000)), 
CASE C.NULLS 
WHEN 'Y' THEN 'YES' ELSE 'NO' 
END , 
CASE 
WHEN C.COLTYPE='CHAR'     THEN 'CHARACTER' 
WHEN C.COLTYPE='VARCHAR'  THEN 'CHARACTER VARYING' 
WHEN C.COLTYPE='LONGVAR'  THEN 'LONG VARCHAR' 
WHEN C.COLTYPE='INTEGER'  THEN 'INTEGER' 
WHEN C.COLTYPE='SMALLINT' THEN 'SMALLINT' 
WHEN C.COLTYPE='BIGINT'   THEN 'BIGINT' 
WHEN C.COLTYPE='REAL'     THEN 'REAL' 
WHEN C.COLTYPE='DOUBLE'   THEN 'DOUBLE PRECISION' 
WHEN C.COLTYPE='DECIMAL'  THEN 'DECIMAL' 
WHEN C.COLTYPE='BLOB'     THEN 'BINARY LARGE OBJECT' 
WHEN C.COLTYPE='CLOB'     THEN 'CHARACTER LARGE OBJECT' 
WHEN C.COLTYPE='DBCLOB'  THEN 'DOUBLE-BYTE CHARACTER LARGE OBJECT' 
WHEN C.COLTYPE='GRAPHIC'  THEN 'GRAPHIC' 
WHEN C.COLTYPE='VARGRAPH' THEN 'GRAPHIC VARYING' 
WHEN C.COLTYPE='LONGVARG' THEN 'LONG VARGRAPHIC' 
WHEN C.COLTYPE='DATALINK' THEN 'DATALINK' 
WHEN C.COLTYPE='TIME'     THEN 'TIME' 
WHEN C.COLTYPE='DATE'     THEN 'DATE' 
WHEN C.COLTYPE='TIMESTMP' THEN 'TIMESTAMP' 
WHEN C.COLTYPE='DATALINK' THEN 'DATALINK' 
WHEN C.COLTYPE='REF'      THEN 'REF' 
WHEN C.COLTYPE='DISTINCT' THEN 'USER-DEFINED' 
WHEN C.COLTYPE='STRUCT'   THEN 'USER-DEFINED' 
ELSE C.TYPENAME 
END, 
CASE 
WHEN  C.COLTYPE ='CHAR'    THEN CAST(C.LENGTH AS INTEGER) 
WHEN  C.COLTYPE='VARCHAR' AND C.LENGTH= -1 
THEN C.LONGLENGTH 
WHEN  C.COLTYPE ='VARCHAR' AND C.LENGTH <> -1 
THEN  CAST(C.LENGTH AS INTEGER) 
WHEN  C.COLTYPE='LONGVAR'  AND C.LENGTH= -1 
THEN C.LONGLENGTH 
WHEN  C.COLTYPE ='LONGVAR' AND C.LENGTH <> -1 
THEN  CAST(C.LENGTH AS INTEGER) 
WHEN  C.COLTYPE= 'CLOB' AND C.LENGTH=-1 
THEN C.LONGLENGTH 
WHEN  C.COLTYPE='CLOB' AND C.LENGTH <>-1 
THEN CAST(C.LENGTH AS INTEGER) 
WHEN  C.COLTYPE ='BLOB'  AND  C.LENGTH =-1 
THEN C.LONGLENGTH 
WHEN  C.COLTYPE='BLOB' AND C.LENGTH <> -1 
THEN CAST(C.LENGTH AS INTEGER) 
WHEN  C.COLTYPE='DBCLOB'  AND C.LENGTH =-1 
THEN C.LONGLENGTH 
WHEN  C.COLTYPE='DBCLOB' AND C.LENGTH <> -1 
THEN  CAST(C.LENGTH AS INTEGER) 
WHEN  C.COLTYPE='GRAPHIC'  THEN  CAST(C.LENGTH AS INTEGER) 
WHEN  C.COLTYPE='VARGRAPH' THEN CAST(C.LENGTH AS INTEGER) 
WHEN  C.COLTYPE='LONGVARG' THEN CAST(C.LENGTH AS INTEGER) 
WHEN  C.COLTYPE='REF'      THEN CAST(C.LENGTH AS INTEGER) 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE 
WHEN  C.COLTYPE ='CHAR' THEN  CAST(C.LENGTH AS INTEGER) 
WHEN   C.COLTYPE='VARCHAR'  AND C.LENGTH= -1 THEN C.LONGLENGTH 
WHEN  C.COLTYPE ='VARCHAR' AND C.LENGTH <> -1 
THEN  CAST(C.LENGTH AS INTEGER) 
WHEN C.COLTYPE='LONGVAR'  AND C.LENGTH= -1 
THEN C.LONGLENGTH 
WHEN  C.COLTYPE ='LONGVAR'  AND C.LENGTH <> -1 
THEN  CAST(C.LENGTH AS INTEGER) 
WHEN C.COLTYPE= 'CLOB' AND C.LENGTH=-1 
THEN C.LONGLENGTH 
WHEN C.COLTYPE='CLOB' AND C.LENGTH <>-1 
THEN CAST(C.LENGTH AS INTEGER) 
WHEN C.COLTYPE ='BLOB'  AND  C.LENGTH =-1 
THEN C.LONGLENGTH 
WHEN C.COLTYPE='BLOB' AND C.LENGTH <> -1 
THEN CAST(C.LENGTH AS INTEGER) 
WHEN C.COLTYPE='DBCLOB'  AND C.LENGTH =-1 
THEN C.LONGLENGTH*2 
WHEN C.COLTYPE='DBCLOB' AND C.LENGTH <> -1 
THEN  CAST(C.LENGTH*2  AS INTEGER) 
WHEN  C.COLTYPE='GRAPHIC'       THEN  CAST(C.LENGTH*2 AS INTEGER) 
WHEN  C.COLTYPE='VARGRAPH'  THEN  CAST(C.LENGTH*2 AS INTEGER) 
WHEN  C.COLTYPE='LONGVARG' THEN CAST(C.LENGTH*2 AS INTEGER) 
WHEN  C.COLTYPE='REF' THEN  CAST(C.LENGTH AS INTEGER) 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE C.COLTYPE 
WHEN 'INTEGER'  THEN 10 
WHEN 'BIGINT'          THEN 19 
WHEN 'SMALLINT'        THEN 5 
WHEN 'REAL'            THEN 24 
WHEN 'DOUBLE'          THEN 53 
WHEN 'DECIMAL' THEN CAST(C.LENGTH AS INTEGER) 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE   C.COLTYPE 
WHEN 'INTEGER'        THEN 10 
WHEN 'BIGINT'         THEN 10 
WHEN 'SMALLINT'       THEN 10 
WHEN 'REAL'           THEN 2 
WHEN 'DOUBLE'         THEN 2 
WHEN 'DECIMAL'        THEN 10 ELSE CAST(NULL AS INTEGER) 
END  , 
CASE  C.COLTYPE 
WHEN 'DECIMAL'     THEN CAST(C.SCALE AS INTEGER) 
WHEN 'INTEGER'     THEN 0 
WHEN 'SMALLINT'    THEN 0 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE  C.COLTYPE 
WHEN 'DATE'          THEN 0 
WHEN 'TIME'          THEN 0 
WHEN 'TIMESTMP'      THEN  CAST(C.SCALE AS INTEGER) 
ELSE  CAST(NULL AS INTEGER) 
END, 
CAST(NULL AS VARCHAR(128)) , 
CAST(NULL AS INTEGER) , 
CASE 
WHEN C.COLTYPE IN ('CHAR'   ,'VARCHAR' ,'LONGVAR' ,'CLOB', 
'GRAPHIC','VARGRAPH','LONGVARG','DBCLOB') 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN C.COLTYPE IN ('CHAR'   ,'VARCHAR' ,'LONGVAR' ,'CLOB', 
'GRAPHIC','VARGRAPH','LONGVARG','DBCLOB') 
THEN CAST('SYSIBM' AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN C.COLTYPE IN ('CHAR'   ,'VARCHAR' ,'LONGVAR' ,'CLOB', 
'GRAPHIC','VARGRAPH','LONGVARG','DBCLOB') 
THEN CAST(CONCAT('IBM',CHAR(C.CODEPAGE)) AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN C.COLTYPE IN ('CHAR'   ,'VARCHAR' ,'LONGVAR' ,'CLOB', 
'GRAPHIC','VARGRAPH','LONGVARG','DBCLOB') 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN C.COLTYPE IN ('CHAR'   ,'VARCHAR' ,'LONGVAR' ,'CLOB', 
'GRAPHIC','VARGRAPH','LONGVARG','DBCLOB') 
THEN CAST('SYSIBM' AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN C.COLTYPE IN ('CHAR'   ,'VARCHAR' ,'LONGVAR' ,'CLOB', 
'GRAPHIC','VARGRAPH','LONGVARG','DBCLOB') 
THEN CAST('IBMDEFAULT' AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CAST (NULL AS VARCHAR(128)), 
CAST (NULL AS VARCHAR(128)), 
CAST (NULL AS VARCHAR(128)), 
CASE C.COLTYPE 
WHEN 'DISTINCT'  THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
WHEN 'REF'       THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
WHEN 'STRUCT'    THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END , 
CASE  C.COLTYPE 
WHEN 'DISTINCT'  THEN TYPESCHEMA 
WHEN 'REF'       THEN P.TARGET_TYPESCHEMA 
WHEN 'STRUCT'    THEN TYPESCHEMA 
ELSE CAST(NULL AS VARCHAR(128)) 
END , 
CASE C.COLTYPE 
WHEN 'DISTINCT'  THEN CAST(TYPENAME AS VARCHAR(128)) 
WHEN 'REF'       THEN CAST(P.TARGET_TYPENAME AS VARCHAR(128)) 
WHEN 'STRUCT'    THEN CAST(TYPENAME AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE C.COLTYPE 
WHEN  'REF'      THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE C.COLTYPE 
WHEN 'REF'       THEN P.SCOPE_TABSCHEMA 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE C.COLTYPE 
WHEN  'REF'      THEN P.SCOPE_TABNAME 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CAST(NULL AS INTEGER), 
CAST ( 
CONCAT('C',CONCAT(HEX(T.CTIME), 
CONCAT(HEX(C.COLNO), SUBSTRING(C.TBNAME,1,103,OCTETS)))) 
AS VARCHAR(128) ), 
CASE 
WHEN C.COLTYPE='REF' AND SUBSTR(P.SPECIAL_PROPS,1,1)='Y' 
THEN 'YES' 
ELSE 'NO' 
END 
FROM  (SYSIBM.SYSTABLES T INNER JOIN 
SYSIBM.SYSCOLUMNS C on 
C.TBCREATOR = T.CREATOR AND C.TBNAME = T.NAME) 
LEFT OUTER JOIN 
SYSIBM.SYSCOLPROPERTIES P 
ON   C.TBCREATOR = P.TABSCHEMA 
AND C.TBNAME = P.TABNAME 
AND C.NAME = P.COLNAME
;

-- View: SYSIBM.COLUMNS_S
CREATE VIEW SYSIBM.COLUMNS_S AS CREATE OR REPLACE VIEW SYSIBM.COLUMNS_S 
(  TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, 
ORDINAL_POSITION, COLUMN_DEFAULT, IS_NULLABLE, DATA_TYPE, 
CHAR_MAX_LENGTH, CHAR_OCTET_LENGTH, NUMERIC_PRECISION, 
NUMERIC_PREC_RADIX, NUMERIC_SCALE, DATETIME_PRECISION, INTERVAL_TYPE, 
INTERVAL_PRECISION, CHAR_SET_CATALOG, CHAR_SET_SCHEMA, 
CHARACTER_SET_NAME, COLLATION_CATALOG, COLLATION_SCHEMA, 
COLLATION_NAME, DOMAIN_CATALOG, DOMAIN_SCHEMA, DOMAIN_NAME, 
UDT_CATALOG, UDT_SCHEMA, UDT_NAME, SCOPE_CATALOG, SCOPE_SCHEMA, 
SCOPE_NAME, MAX_CARDINALITY, DTD_IDENTIFIER, IS_SELF_REF ) 
AS SELECT 
TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, 
ORDINAL_POSITION, COLUMN_DEFAULT, IS_NULLABLE, DATA_TYPE, 
CHARACTER_MAXIMUM_LENGTH, CHARACTER_OCTET_LENGTH, NUMERIC_PRECISION, 
NUMERIC_PRECISION_RADIX, NUMERIC_SCALE, DATETIME_PRECISION, 
INTERVAL_TYPE, INTERVAL_PRECISION, CHARACTER_SET_CATALOG, 
CHARACTER_SET_SCHEMA, CHARACTER_SET_NAME, COLLATION_CATALOG, 
COLLATION_SCHEMA, COLLATION_NAME, DOMAIN_CATALOG, DOMAIN_SCHEMA, 
DOMAIN_NAME, UDT_CATALOG, UDT_SCHEMA, UDT_NAME, SCOPE_CATALOG, 
SCOPE_SCHEMA, SCOPE_NAME, MAXIMUM_CARDINALITY, DTD_IDENTIFIER, 
IS_SELF_REFERENCING 
FROM SYSIBM.COLUMNS
;

-- View: SYSIBM.DUAL
CREATE VIEW SYSIBM.DUAL AS CREATE OR REPLACE view sysibm.dual (dummy) as values (char('X')) 

;

-- View: SYSIBM.PARAMETERS
CREATE VIEW SYSIBM.PARAMETERS AS CREATE OR REPLACE VIEW SYSIBM.PARAMETERS 
( 
SPECIFIC_CATALOG, SPECIFIC_SCHEMA, SPECIFIC_NAME, 
ORDINAL_POSITION, PARAMETER_MODE, 
IS_RESULT, AS_LOCATOR, PARAMETER_NAME, 
FROM_SQL_SPECIFIC_CATALOG, FROM_SQL_SPECIFIC_SCHEMA, 
FROM_SQL_SPECIFIC_NAME, 
TO_SQL_SPECIFIC_CATALOG, TO_SQL_SPECIFIC_SCHEMA, 
TO_SQL_SPECIFIC_NAME, 
DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
CHARACTER_OCTET_LENGTH, CHARACTER_SET_CATALOG, 
CHARACTER_SET_SCHEMA, CHARACTER_SET_NAME, 
COLLATION_CATALOG, COLLATION_SCHEMA, COLLATION_NAME, 
NUMERIC_PRECISION, NUMERIC_PRECISION_RADIX, NUMERIC_SCALE, 
DATETIME_PRECISION, INTERVAL_TYPE, INTERVAL_PRECISION, 
UDT_CATALOG, UDT_SCHEMA, UDT_NAME, SCOPE_CATALOG, 
SCOPE_SCHEMA, SCOPE_NAME, MAXIMUM_CARDINALITY, 
DTD_IDENTIFIER 
) 
AS WITH 
FROM_SQL(FROM_CATALOG, FROM_SCHEMA, FROM_NAME, FROM_GRPNAME, 
FROM_ROUTINE_ID) AS 
( SELECT CURRENT SERVER, R.ROUTINESCHEMA, R.SPECIFICNAME, 
P.TRANSFORM_GRPNAME, R.ROUTINE_ID 
FROM SYSIBM.SYSROUTINEPARMS P, SYSIBM.SYSROUTINES R, 
SYSIBM.SYSTRANSFORMS T 
WHERE  P.TRANSFORM_GRPNAME = T.GROUPNAME 
AND  T.FROMSQL_FUNCID = R.ROUTINE_ID 
AND R.ROUTINESCHEMA <> 'SYSFUN' 
) 
SELECT CAST(CURRENT SERVER AS VARCHAR(128)), ROUTINESCHEMA, SPECIFICNAME, 
CASE ROWTYPE 
WHEN 'P' THEN CAST(ORDINAL AS INTEGER) 
WHEN 'B'      THEN CAST(ORDINAL AS INTEGER) 
WHEN 'O'   THEN  CAST(ORDINAL AS INTEGER) 
END, 
CASE ROWTYPE 
WHEN 'P'        THEN 'IN' 
WHEN 'O'        THEN 'OUT' 
WHEN 'B'        THEN 'INOUT' 
END, 
CAST('NO' AS VARCHAR(2)), 
CASE P.LOCATOR 
WHEN 'Y'       THEN 'YES' 
WHEN 'N'       THEN 'NO' 
END, 
PARMNAME, 
CASE 
WHEN P.ROWTYPE='P'  AND (P.ROUTINETYPE ='F' OR P.ROUTINETYPE='M') 
THEN CAST(FROM_CATALOG AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN P.ROWTYPE='P'  AND (P.ROUTINETYPE ='F' OR P.ROUTINETYPE='M') 
THEN  FROM_SCHEMA ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN P.ROWTYPE='P'  AND (P.ROUTINETYPE ='F' OR P.ROUTINETYPE='M') 
THEN CAST(FROM_NAME AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CAST(NULL AS VARCHAR(128)), 
CAST(NULL AS VARCHAR(128)), 
CAST(NULL AS VARCHAR(128)), 
CASE 
WHEN P.TYPENAME='CHARACTER'       THEN 'CHARACTER' 
WHEN P.TYPENAME='VARCHAR'         THEN 'CHARACTER VARYING' 
WHEN P.TYPENAME='LONG VARCHAR'    THEN 'LONG VARCHAR' 
WHEN P.TYPENAME='INTEGER'         THEN 'INTEGER' 
WHEN P.TYPENAME='SMALLINT'        THEN 'SMALLINT' 
WHEN P.TYPENAME='BIGINT'          THEN 'BIGINT' 
WHEN P.TYPENAME='REAL'            THEN 'REAL' 
WHEN P.TYPENAME='DOUBLE'          THEN 'DOUBLE PRECISION' 
WHEN P.TYPENAME='DECIMAL'         THEN 'DECIMAL' 
WHEN P.TYPENAME='BLOB'            THEN 'BINARY LARGE OBJECT' 
WHEN P.TYPENAME='CLOB'            THEN 'CHARACTER LARGE OBJECT' 
WHEN P.TYPENAME='DBCLOB'  THEN 'DOUBLE-BYTE CHARACTER LARGE OBJECT' 
WHEN P.TYPENAME='GRAPHIC'         THEN 'GRAPHIC' 
WHEN P.TYPENAME='VARGRAPHIC'      THEN 'GRAPHIC VARYING' 
WHEN P.TYPENAME='LONG VARGRAPHIC' THEN 'LONG VARGRAPHIC' 
WHEN P.TYPENAME='DATALINK'        THEN 'DATALINK' 
WHEN P.TYPENAME='TIME'            THEN 'TIME' 
WHEN P.TYPENAME='DATE'            THEN 'DATE' 
WHEN P.TYPENAME='TIMESTAMP'       THEN 'TIMESTAMP' 
WHEN P.TYPENAME='REFERENCE'       THEN 'REF' 
WHEN P.TYPESCHEMA<>'SYSIBM'       THEN 'USER-DEFINED' 
ELSE P.TYPENAME 
END, 
CASE 
WHEN P.TYPENAME IN ('CHARACTER', 'VARCHAR', 'LONG VARCHAR', 'CLOB', 
'GRAPHIC', 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') THEN P.LENGTH 
WHEN P.TYPENAME='BLOB'            THEN P.LENGTH 
WHEN P.TYPENAME='REFERENCE'       THEN P.LENGTH 
ELSE  CAST(NULL AS INTEGER) 
END, 
CASE 
WHEN P.TYPENAME IN 
('CHARACTER', 'VARCHAR' , 'LONG VARCHAR' , 'CLOB') THEN P.LENGTH 
WHEN P.TYPENAME IN 
('GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN P.LENGTH * 2 
WHEN P.TYPENAME='BLOB'            THEN P.LENGTH 
WHEN P.TYPENAME='REFERENCE'       THEN P.LENGTH 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE 
WHEN P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST('SYSIBM' AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST(CONCAT('IBM', CHAR(P.CODEPAGE)) AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST('SYSIBM' AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST('IBMDEFAULT' AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE P.TYPENAME 
WHEN 'INTEGER'      THEN 10 
WHEN 'BIGINT'       THEN 19 
WHEN 'SMALLINT'     THEN 5 
WHEN 'REAL'         THEN 24 
WHEN 'DOUBLE'       THEN 53 
WHEN 'DECIMAL'      THEN P.LENGTH 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE  P.TYPENAME 
WHEN 'INTEGER'      THEN 10 
WHEN 'BIGINT'       THEN 10 
WHEN 'SMALLINT'     THEN 10 
WHEN 'REAL'         THEN 2 
WHEN 'DOUBLE'       THEN 2 
WHEN 'DECIMAL'      THEN 10 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE P.TYPENAME 
WHEN 'DECIMAL'      THEN CAST(P.SCALE AS INTEGER) 
WHEN 'INTEGER'      THEN 0 
WHEN 'SMALLINT'     THEN 0 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE P.TYPENAME 
WHEN 'DATE'         THEN 0 
WHEN 'TIME'         THEN 0 
WHEN 'TIMESTAMP'    THEN CAST(P.SCALE AS INTEGER) 
ELSE CAST(NULL AS INTEGER) 
END, 
CAST(NULL AS VARCHAR(128)) , 
CAST(NULL AS INTEGER) , 
CASE 
WHEN P.TYPENAME = 'REFERENCE' 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
WHEN P.TYPESCHEMA <> 'SYSIBM' 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN P.TYPENAME = 'REFERENCE' THEN P.TARGET_TYPESCHEMA 
WHEN P.TYPESCHEMA <> 'SYSIBM' THEN TYPESCHEMA 
ELSE CAST(NULL AS VARCHAR(128)) 
END , 
CASE 
WHEN P.TYPENAME = 'REFERENCE' 
THEN CAST(P.TARGET_TYPENAME AS VARCHAR(128)) 
WHEN P.TYPESCHEMA <> 'SYSIBM' 
THEN CAST(P.TYPENAME AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN  P.TYPENAME ='REFERENCE' AND P.SCOPE_TABSCHEMA IS NOT NULL 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN  P.TYPENAME='REFERENCE' THEN P.SCOPE_TABSCHEMA 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN  P.TYPENAME ='REFERENCE' THEN P.SCOPE_TABNAME 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CAST(NULL AS INTEGER), 
CAST(CONCAT('P',CONCAT(HEX(FROM_ROUTINE_ID),CONCAT(P.ROWTYPE, 
HEX(P.ORDINAL)))) AS VARCHAR(128)) 
FROM  SYSIBM.SYSROUTINEPARMS  P 
LEFT OUTER JOIN FROM_SQL ON P.TRANSFORM_GRPNAME = FROM_SQL.FROM_GRPNAME 
WHERE P.ROWTYPE IN  ('P', 'O', 'B') 
AND P.ORDINAL > 0
;

-- View: SYSIBM.PARAMETERS_S
CREATE VIEW SYSIBM.PARAMETERS_S AS CREATE OR REPLACE VIEW SYSIBM.PARAMETERS_S 
( 
SPECIFIC_CATALOG, SPECIFIC_SCHEMA , SPECIFIC_NAME , ORDINAL_POSITION , 
PARAMETER_MODE, IS_RESULT  , AS_LOCATOR  , PARAMETER_NAME    , 
FROM_SQL_SPEC_CAT, FROM_SQL_SPEC_SCH, FROM_SQL_SPEC_NAME, 
TO_SQL_SPEC_CAT, TO_SQL_SPEC_SCHEMA, TO_SQL_SPEC_NAME, DATA_TYPE, 
CHAR_MAX_LENGTH, CHAR_OCTET_LENGTH, CHAR_SET_CATALOG, CHAR_SET_SCHEMA, 
CHARACTER_SET_NAME, COLLATION_CATALOG, COLLATION_SCHEMA, 
COLLATION_NAME, NUMERIC_PRECISION, NUMERIC_PREC_RADIX, NUMERIC_SCALE, 
DATETIME_PRECISION, INTERVAL_TYPE, INTERVAL_PRECISION, UDT_CATALOG, 
UDT_SCHEMA, UDT_NAME, SCOPE_CATALOG, SCOPE_SCHEMA, SCOPE_NAME, 
MAX_CARDINALITY, DTD_IDENTIFIER 
) AS 
SELECT 
SPECIFIC_CATALOG, SPECIFIC_SCHEMA, SPECIFIC_NAME, ORDINAL_POSITION, 
PARAMETER_MODE, IS_RESULT, AS_LOCATOR, PARAMETER_NAME, 
FROM_SQL_SPECIFIC_CATALOG, FROM_SQL_SPECIFIC_SCHEMA, 
FROM_SQL_SPECIFIC_NAME, TO_SQL_SPECIFIC_CATALOG, 
TO_SQL_SPECIFIC_SCHEMA, TO_SQL_SPECIFIC_NAME, DATA_TYPE, 
CHARACTER_MAXIMUM_LENGTH, CHARACTER_OCTET_LENGTH, 
CHARACTER_SET_CATALOG, CHARACTER_SET_SCHEMA, CHARACTER_SET_NAME, 
COLLATION_CATALOG, COLLATION_SCHEMA, COLLATION_NAME, NUMERIC_PRECISION, 
NUMERIC_PRECISION_RADIX, NUMERIC_SCALE, DATETIME_PRECISION, 
INTERVAL_TYPE, INTERVAL_PRECISION, UDT_CATALOG, UDT_SCHEMA, UDT_NAME, 
SCOPE_CATALOG, SCOPE_SCHEMA, SCOPE_NAME, MAXIMUM_CARDINALITY, 
DTD_IDENTIFIER 
FROM SYSIBM.PARAMETERS
;

-- View: SYSIBM.REFERENTIAL_CONSTRAINTS
CREATE VIEW SYSIBM.REFERENTIAL_CONSTRAINTS AS CREATE OR REPLACE VIEW SYSIBM.REFERENTIAL_CONSTRAINTS 
( CONSTRAINT_CATALOG, CONSTRAINT_SCHEMA, CONSTRAINT_NAME, 
UNIQUE_CONSTRAINT_CATALOG, UNIQUE_CONSTRAINT_SCHEMA, 
UNIQUE_CONSTRAINT_NAME, MATCH_OPTION, UPDATE_RULE, DELETE_RULE 
) AS 
SELECT CAST(CURRENT SERVER  AS VARCHAR(128)), 
CREATOR , 
CAST(RELNAME            AS VARCHAR(128)), 
CAST(CURRENT SERVER     AS VARCHAR(128)), 
REFTBCREATOR  , 
CAST(REFKEYNAME     AS VARCHAR(128)), 
CAST('NONE' AS VARCHAR(4)) , 
CASE UPDATERULE 
WHEN 'N'      THEN  'RESTRICT' 
WHEN 'A'      THEN 'NO ACTION' 
END , 
CASE DELETERULE 
WHEN 'C'      THEN  'CASCADE' 
WHEN 'N'      THEN 'SET NULL' 
WHEN 'R'      THEN 'RESTRICT' 
WHEN 'A'      THEN 'NO ACTION' 
END 
FROM SYSIBM.SYSRELS
;

-- View: SYSIBM.REF_CONSTRAINTS
CREATE VIEW SYSIBM.REF_CONSTRAINTS AS CREATE OR REPLACE VIEW SYSIBM.REF_CONSTRAINTS 
( CONSTRAINT_CATALOG, CONSTRAINT_SCHEMA, CONSTRAINT_NAME, 
UNIQUE_CONSTR_CAT, UNIQUE_CONSTR_SCH, UNIQUE_CONSTR_NAME, 
MATCH_OPTION, UPDATE_RULE, DELETE_RULE 
) AS 
SELECT CONSTRAINT_CATALOG, CONSTRAINT_SCHEMA, CONSTRAINT_NAME, 
UNIQUE_CONSTRAINT_CATALOG, UNIQUE_CONSTRAINT_SCHEMA, 
UNIQUE_CONSTRAINT_NAME, MATCH_OPTION, UPDATE_RULE, DELETE_RULE 
FROM SYSIBM.REFERENTIAL_CONSTRAINTS
;

-- View: SYSIBM.ROUTINES
CREATE VIEW SYSIBM.ROUTINES AS CREATE OR REPLACE VIEW SYSIBM.ROUTINES 
( 
SPECIFIC_CATALOG, SPECIFIC_SCHEMA, SPECIFIC_NAME, 
ROUTINE_CATALOG, ROUTINE_SCHEMA, ROUTINE_NAME, 
ROUTINE_TYPE, MODULE_CATALOG, MODULE_SCHEMA, MODULE_NAME, 
UDT_CATALOG, UDT_SCHEMA, UDT_NAME, 
DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, CHARACTER_OCTET_LENGTH, 
CHARACTER_SET_CATALOG, CHARACTER_SET_SCHEMA, 
CHARACTER_SET_NAME, COLLATION_CATALOG, COLLATION_SCHEMA, 
COLLATION_NAME, NUMERIC_PRECISION, NUMERIC_PRECISION_RADIX, 
NUMERIC_SCALE,  DATETIME_PRECISION, INTERVAL_TYPE, 
INTERVAL_PRECISION, TYPE_UDT_CATALOG, TYPE_UDT_SCHEMA, 
TYPE_UDT_NAME, SCOPE_CATALOG, SCOPE_SCHEMA, SCOPE_NAME, 
MAXIMUM_CARDINALITY, DTD_IDENTIFIER, ROUTINE_BODY, 
ROUTINE_DEFINITION, EXTERNAL_NAME, EXTERNAL_LANGUAGE, 
PARAMETER_STYLE, IS_DETERMINISTIC, 
SQL_DATA_ACCESS, IS_NULL_CALL, SQL_PATH, SCHEMA_LEVEL_ROUTINE, 
MAX_DYNAMIC_RESULT_SETS, IS_USER_DEFINED_CAST, 
IS_IMPLICITLY_INVOCABLE, SECURITY_TYPE, TO_SQL_SPECIFIC_CATALOG, 
TO_SQL_SPECIFIC_SCHEMA, TO_SQL_SPECIFIC_NAME, 
AS_LOCATOR, CREATED, LAST_ALTERED 
) AS 
WITH TO_SQL(TO_CATALOG, TO_SCHEMA, TO_NAME, TO_GRPNAME) AS 
( SELECT CURRENT SERVER, R.ROUTINESCHEMA, R.SPECIFICNAME, 
P.TRANSFORM_GRPNAME 
FROM SYSIBM.SYSROUTINEPARMS P, 
SYSIBM.SYSROUTINES R, 
SYSIBM.SYSTRANSFORMS T 
WHERE  P. TRANSFORM_GRPNAME = T.GROUPNAME 
AND       T.TOSQL_FUNCID = R.ROUTINE_ID 
) 
SELECT CAST(CURRENT SERVER AS VARCHAR(128)), 
R.ROUTINESCHEMA, 
CAST(R.SPECIFICNAME     AS VARCHAR(128)), 
CAST(CURRENT SERVER     AS VARCHAR(128)), 
R.ROUTINESCHEMA, 
CAST(R.ROUTINENAME AS VARCHAR(128)), 
CASE 
WHEN R.ROUTINETYPE='P'  THEN 'PROCEDURE' 
WHEN R.ROUTINETYPE='M' AND METHODPROPERTY ='S' 
THEN 'STATIC METHOD' 
WHEN R.ROUTINETYPE='M' AND METHODPROPERTY='I' 
THEN 'INSTANCE METHOD' 
WHEN R.ROUTINETYPE='M' AND METHODPROPERTY='C' 
THEN 'CONSTRUCTOR METHOD' 
WHEN R.ROUTINETYPE='F'  THEN 'FUNCTION' 
END, 
CAST(NULL AS VARCHAR(128)), 
CAST(NULL AS VARCHAR(128)), 
CAST(NULL AS VARCHAR(128)), 
CASE R.ROUTINETYPE 
WHEN 'M'   THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE R.ROUTINETYPE 
WHEN 'M'  THEN SUBJECT_TYPESCHEMA 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE R.ROUTINETYPE 
WHEN 'M'    THEN CAST(SUBJECT_TYPENAME AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='CHARACTER' THEN 'CHARACTER' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='VARCHAR'   THEN 'CHARACTER VARYING' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='LONG VARCHAR' THEN 'LONG VARCHAR' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='INTEGER'   THEN 'INTEGER' 
WHEN  (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='SMALLINT'  THEN 'SMALLINT' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='BIGINT'    THEN 'BIGINT' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REAL'  THEN 'REAL' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DOUBLE'    THEN 'DOUBLE PRECISION' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DECIMAL'   THEN 'DECIMAL' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME = 'BLOB'     THEN 'BINARY LARGE OBJECT' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='CLOB'      THEN 'CHARACTER LARGE OBJECT' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DBCLOB'    THEN 'DOUBLE-BYTE CHARACTER 
LARGE OBJECT' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='GRAPHIC'   THEN 'GRAPHIC' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='VARGRAPHIC' THEN 'GRAPHIC VARYING' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='LONG VARGRAPHIC'   THEN 'LONG VARGRAPHIC' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DATALINK'      THEN 'DATALINK' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='TIME'      THEN 'TIME' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DATE'      THEN 'DATE' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='TIMESTAMP'     THEN 'TIMESTAMP' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REFERENCE'     THEN 'REF' 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPESCHEMA <> 'SYSIBM'    THEN 'USER-DEFINED' 
WHEN (R.ROUTINETYPE ='P')            THEN CAST(NULL AS 
VARCHAR(128)) 
ELSE P.TYPENAME 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN P.LENGTH 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='BLOB'          THEN P.LENGTH 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REFERENCE'     THEN P.LENGTH 
ELSE CAST (NULL AS INTEGER) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB') 
THEN P.LENGTH 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME IN 
('GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN P.LENGTH*2 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME = 'BLOB'         THEN P.LENGTH 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME='REFERENCE'      THEN P.LENGTH 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST( 'SYSIBM' AS VARCHAR(128)) 
ELSE CAST( NULL  AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST(CONCAT('IBM',CHAR(P.CODEPAGE)) AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME IN 
('CHARACTRE', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST( 'SYSIBM' AS VARCHAR(128)) 
ELSE CAST( NULL  AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME IN 
('CHARACTER', 'VARCHAR'   , 'LONG VARCHAR'   , 'CLOB'  , 
'GRAPHIC'  , 'VARGRAPHIC', 'LONG VARGRAPHIC', 'DBCLOB') 
THEN CAST('IBMDEFAULT' AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='INTEGER'   THEN 10 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='BIGINT'    THEN 19 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='SMALLINT'  THEN 5 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REAL'      THEN 24 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DOUBLE'    THEN 53 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DECIMAL'   THEN P.LENGTH 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='INTEGER'   THEN 10 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='BIGINT'    THEN 10 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='SMALLINT'  THEN 10 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REAL'      THEN  2 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DOUBLE'    THEN 2 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DECIMAL'   THEN  10 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DECIMAL'   THEN  CAST(P.SCALE AS 
INTEGER) 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='INTEGER'   THEN  0 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='SMALLINT'  THEN  0 
ELSE CAST(NULL AS INTEGER) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='DATE'      THEN  0 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='TIME'      THEN 0 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='TIMESTAMP' THEN CAST(P.SCALE AS 
INTEGER) 
ELSE CAST(NULL AS INTEGER) 
END, 
CAST(NULL AS VARCHAR(128)) , 
CAST(NULL AS INTEGER) , 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REFERENCE'     THEN 
CAST(CURRENT SERVER AS VARCHAR(128)) 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPESCHEMA <> 'SYSIBM'    THEN 
CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REFERENCE'    THEN TARGET_TYPESCHEMA 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPESCHEMA <> 'SYSIBM'   THEN TYPESCHEMA 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REFERENCE'    THEN 
CAST(TARGET_TYPENAME AS VARCHAR(128)) 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPESCHEMA <>'SYSIBM'      THEN 
CAST(TYPENAME AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REFERENCE'  THEN 
CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REFERENCE'    THEN P.SCOPE_TABSCHEMA 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN (R.ROUTINETYPE ='M' OR R.ROUTINETYPE='F' ) 
AND P.TYPENAME ='REFERENCE'  THEN P.SCOPE_TABNAME 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CAST(NULL AS INTEGER), 
CAST(CONCAT('R',HEX(R.ROUTINE_ID)) AS VARCHAR(128)), 
CASE LANGUAGE 
WHEN 'SQL'   THEN 'SQL' 
ELSE 'EXTERNAL' 
END, 
CASE LANGUAGE 
WHEN 'SQL'      THEN TEXT 
ELSE CAST(NULL AS CLOB(1M)) 
END, 
CAST(CASE 
WHEN LANGUAGE  <>  'SQL'  THEN  IMPLEMENTATION 
ELSE   NULL 
END AS VARCHAR(279) ), 
CASE 
WHEN LANGUAGE <>' SQL' 
THEN CAST(LANGUAGE AS VARCHAR(22)) 
ELSE CAST(NULL AS VARCHAR(22)) 
END, 
CASE PARAMETER_STYLE 
WHEN 'DB2GENRL'     THEN CAST('DB2GENERAL' AS VARCHAR(22)) 
WHEN 'DB2DARI'      THEN CAST('DB2DARI'    AS VARCHAR(22)) 
WHEN 'DB2SQL'       THEN CAST('DB2SQL'     AS VARCHAR(22)) 
WHEN 'JAVA'         THEN CAST('JAVA'       AS VARCHAR(22)) 
WHEN 'GENERAL'      THEN CAST('GENERAL'    AS VARCHAR(22)) 
WHEN 'GNRLNULL'     THEN 
CAST('GENERAL WITH NULLS' AS VARCHAR(22)) 
ELSE CAST(NULL AS VARCHAR(22)) 
END, 
CASE 
WHEN DETERMINISTIC='Y'      THEN 'YES' 
WHEN DETERMINISTIC='N'      THEN 'NO' 
ELSE 'YES' 
END, 
CASE SQL_DATA_ACCESS 
WHEN 'C'        THEN 'CONTAINS SQL' 
WHEN 'M'        THEN 'MODIFIES SQL DATA' 
WHEN 'R'        THEN 'READS SQL DATA' 
WHEN 'N'        THEN 'NO SQL' 
ELSE 'NO SQL' 
END, 
CASE 
WHEN (R.ROUTINETYPE ='F' OR R.ROUTINETYPE='M') 
AND R.NULL_CALL ='N'     THEN 'YES' 
WHEN (R.ROUTINETYPE='F' AND R.ROUTINETYPE='M') 
AND R.NULL_CALL='Y'   THEN 'NO' 
WHEN R.ROUTINETYPE='P' THEN NULL 
ELSE 'NO' 
END, 
CASE LANGUAGE 
WHEN 'SQL'     THEN CAST(FUNC_PATH AS VARCHAR(558)) 
ELSE CAST(NULL AS VARCHAR(558)) 
END, 
CAST('YES' AS VARCHAR(3)), 
CASE R.ROUTINETYPE 
WHEN 'P'        THEN CAST(RESULT_SETS AS INTEGER) 
ELSE 0 
END, 
CASE CAST_FUNCTION 
WHEN 'Y'        THEN 'YES' 
ELSE 'NO' 
END, 
CASE CAST_FUNCTION 
WHEN 'Y'       THEN 'YES' 
ELSE CAST(NULL AS VARCHAR(3)) 
END, 
CASE 
WHEN  LANGUAGE <> 'SQL'     THEN 'IMPLEMENTATION  DEFINED' 
ELSE CAST(NULL AS VARCHAR(22)) 
END, 
CAST(TO_CATALOG AS VARCHAR(128)), 
TO_SCHEMA, 
CAST(TO_NAME AS VARCHAR(128)), 
CASE P.LOCATOR 
WHEN 'Y'    THEN 'YES' 
WHEN 'N'    THEN 'NO' 
END, 
CREATEDTS, 
ALTEREDTS 
FROM  (SYSIBM.SYSROUTINES R 
LEFT OUTER JOIN 
SYSIBM.SYSROUTINEPARMS P 
ON   R.SPECIFICNAME = P.SPECIFICNAME 
AND R.ROUTINESCHEMA = P.ROUTINESCHEMA 
AND P.ROWTYPE ='C' 
) 
LEFT OUTER JOIN 
TO_SQL 
ON P.TRANSFORM_GRPNAME = TO_SQL.TO_GRPNAME 
WHERE R.FUNCTION_TYPE NOT IN ('T', 'R') 
AND R.ROUTINESCHEMA <> 'SYSFUN'
;

-- View: SYSIBM.ROUTINES_S
CREATE VIEW SYSIBM.ROUTINES_S AS CREATE OR REPLACE VIEW SYSIBM.ROUTINES_S 
( 
SPECIFIC_CATALOG, SPECIFIC_SCHEMA, SPECIFIC_NAME, ROUTINE_CATALOG, 
ROUTINE_SCHEMA    , ROUTINE_NAME      , ROUTINE_TYPE  , MODULE_CATALOG    , 
MODULE_SCHEMA     , MODULE_NAME       , UDT_CATALOG   , UDT_SCHEMA        , 
UDT_NAME          , DATA_TYPE        , CHAR_MAX_LENGTH, CHAR_OCTET_LENGTH , 
CHAR_SET_CATALOG, CHAR_SET_SCHEMA, CHARACTER_SET_NAME, COLLATION_CATALOG , 
COLLATION_SCHEMA, COLLATION_NAME, NUMERIC_PRECISION , NUMERIC_PREC_RADIX, 
NUMERIC_SCALE, DATETIME_PRECISION, INTERVAL_TYPE     , INTERVAL_PRECISION, 
TYPE_UDT_CATALOG, TYPE_UDT_SCHEMA, TYPE_UDT_NAME     , SCOPE_CATALOG     , 
SCOPE_SCHEMA      , SCOPE_NAME    , MAX_CARDINALITY   , DTD_IDENTIFIER    , 
ROUTINE_BODY  , ROUTINE_DEFINITION, EXTERNAL_NAME     , EXTERNAL_LANGUAGE , 
PARAMETER_STYLE, IS_DETERMINISTIC, SQL_DATA_ACCESS  , IS_NULL_CALL      , 
SQL_PATH    , SCH_LEVEL_ROUTINE , MAX_DYN_RESLT_SETS, IS_USER_DEFND_CAST, 
IS_IMP_INVOCABLE , SECURITY_TYPE, TO_SQL_SPEC_CAT   , TO_SQL_SPEC_SCHEMA, 
TO_SQL_SPEC_NAME  , AS_LOCATOR  , CREATED           , LAST_ALTERED 
) 
AS SELECT 
SPECIFIC_CATALOG, SPECIFIC_SCHEMA, SPECIFIC_NAME, ROUTINE_CATALOG, 
ROUTINE_SCHEMA, ROUTINE_NAME, ROUTINE_TYPE, MODULE_CATALOG, 
MODULE_SCHEMA, MODULE_NAME, UDT_CATALOG, UDT_SCHEMA, 
UDT_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, CHARACTER_OCTET_LENGTH, 
CHARACTER_SET_CATALOG, CHARACTER_SET_SCHEMA, CHARACTER_SET_NAME, 
COLLATION_CATALOG, COLLATION_SCHEMA, COLLATION_NAME, NUMERIC_PRECISION, 
NUMERIC_PRECISION_RADIX, NUMERIC_SCALE, DATETIME_PRECISION, INTERVAL_TYPE, 
INTERVAL_PRECISION, TYPE_UDT_CATALOG, TYPE_UDT_SCHEMA, TYPE_UDT_NAME, 
SCOPE_CATALOG, SCOPE_SCHEMA, SCOPE_NAME, MAXIMUM_CARDINALITY, DTD_IDENTIFIER, 
ROUTINE_BODY, ROUTINE_DEFINITION, EXTERNAL_NAME, EXTERNAL_LANGUAGE, 
PARAMETER_STYLE, IS_DETERMINISTIC, SQL_DATA_ACCESS, IS_NULL_CALL, 
SQL_PATH, SCHEMA_LEVEL_ROUTINE, MAX_DYNAMIC_RESULT_SETS, IS_USER_DEFINED_CAST, 
IS_IMPLICITLY_INVOCABLE, SECURITY_TYPE, TO_SQL_SPECIFIC_CATALOG, 
TO_SQL_SPECIFIC_SCHEMA, TO_SQL_SPECIFIC_NAME, AS_LOCATOR, CREATED, LAST_ALTERED 
FROM SYSIBM.ROUTINES
;

-- View: SYSIBM.SQLCOLPRIVILEGES
CREATE VIEW SYSIBM.SQLCOLPRIVILEGES AS CREATE OR REPLACE VIEW SYSIBM.SQLCOLPRIVILEGES(   TABLE_CAT,   TABLE_SCHEM,   TABLE_NAME,   COLUMN_NAME,   GRANTOR,   GRANTEE,   PRIVILEGE,   IS_GRANTABLE,   DBNAME)  AS   SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(T.TCREATOR),     T.TTNAME,     C.NAME,     RTRIM(T.GRANTOR),     RTRIM(T.GRANTEE),     CAST('REFERENCES' AS VARCHAR(10)),     CASE WHEN T.REFAUTH = 'G' THEN 'YES' ELSE 'NO' END,     CAST( NULL AS VARCHAR(8) )   FROM     SYSIBM.SYSTABAUTH T,     SYSIBM.SYSCOLUMNS C   WHERE     T.TCREATOR = C.TBCREATOR     AND T.TTNAME = C.TBNAME     AND T.REFAUTH IN ('Y', 'G') UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(A.CREATOR),    A.TNAME,    C.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('REFERENCES' AS VARCHAR(10)),    CASE WHEN A.GRANTABLE='G' THEN 'YES' ELSE 'NO' END,    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSCOLAUTH A,    SYSIBM.SYSCOLUMNS C  WHERE    A.CREATOR=C.TBCREATOR    AND A.TNAME=C.TBNAME    AND A.COLNAME=C.NAME    AND A.PRIVTYPE='R' UNION   SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(T.TCREATOR),     T.TTNAME,     C.NAME,     RTRIM(T.GRANTOR),     RTRIM(T.GRANTEE),     CAST('UPDATE' AS VARCHAR(10)),     CASE WHEN T.UPDATEAUTH = 'G' THEN 'YES' ELSE 'NO' END,     CAST( NULL AS VARCHAR(8) )   FROM     SYSIBM.SYSTABAUTH T,     SYSIBM.SYSCOLUMNS C   WHERE     T.TCREATOR = C.TBCREATOR     AND T.TTNAME = C.TBNAME     AND T.UPDATEAUTH IN ('Y', 'G') UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(A.CREATOR),    A.TNAME,    C.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('UPDATE' AS VARCHAR(10)),    CASE WHEN A.GRANTABLE='G' THEN 'YES' ELSE 'NO' END,    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSCOLAUTH A,    SYSIBM.SYSCOLUMNS C  WHERE    A.CREATOR=C.TBCREATOR    AND A.TNAME=C.TBNAME    AND A.COLNAME=C.NAME    AND A.PRIVTYPE='U' UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.TCREATOR),    T.TTNAME,    C.NAME,    RTRIM(GRANTOR),    RTRIM(T.GRANTEE),    CAST('SELECT' AS VARCHAR(10)),    CASE WHEN T.SELECTAUTH='G' THEN 'YES' ELSE 'NO' END,    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH T,    SYSIBM.SYSCOLUMNS C  WHERE    T.TCREATOR=C.TBCREATOR    AND T.TTNAME=C.TBNAME    AND T.SELECTAUTH IN ('Y', 'G') UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.TCREATOR),    T.TTNAME,    C.NAME,    RTRIM(GRANTOR),    RTRIM(T.GRANTEE),    CAST('INSERT' AS VARCHAR(10)),    CASE WHEN T.INSERTAUTH='G' THEN 'YES' ELSE 'NO' END,    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH T,    SYSIBM.SYSCOLUMNS C  WHERE    T.TCREATOR=C.TBCREATOR    AND T.TTNAME=C.TBNAME    AND T.INSERTAUTH IN ('Y', 'G') UNION   SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(Z.CREATOR),     Z.NAME,     C.NAME,     RTRIM(T.GRANTOR),     RTRIM(T.GRANTEE),     CAST('REFERENCES' AS VARCHAR(10)),     CASE WHEN T.REFAUTH = 'G' THEN 'YES' ELSE 'NO' END,     CAST( NULL AS VARCHAR(8) )   FROM     SYSIBM.SYSTABAUTH T,     SYSIBM.SYSCOLUMNS C,     SYSIBM.SYSTABLES  Z,     TABLE(SYSPROC.BASE_TABLE(Z.CREATOR, Z.NAME)) AS B   WHERE     T.TCREATOR = C.TBCREATOR     AND T.TTNAME = C.TBNAME     AND T.REFAUTH IN ('Y', 'G')     AND Z.TYPE = 'A'     AND B.BASESCHEMA = T.TCREATOR     AND B.BASENAME = T.TTNAME UNION   SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(Z.CREATOR),     Z.NAME,     C.NAME,     RTRIM(A.GRANTOR),     RTRIM(A.GRANTEE),     CAST('REFERENCES' AS VARCHAR(10)),     CASE WHEN A.GRANTABLE = 'G' THEN 'YES' ELSE 'NO' END,     CAST( NULL AS VARCHAR(8) )   FROM     SYSIBM.SYSCOLAUTH A,     SYSIBM.SYSCOLUMNS C,     SYSIBM.SYSTABLES  Z,     TABLE(SYSPROC.BASE_TABLE(Z.CREATOR, Z.NAME)) AS B   WHERE     A.CREATOR = C.TBCREATOR     AND A.TNAME = C.TBNAME     AND A.COLNAME=C.NAME     AND A.PRIVTYPE ='R'     AND Z.TYPE = 'A'     AND B.BASESCHEMA = A.CREATOR     AND B.BASENAME = A.TNAME UNION   SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(Z.CREATOR),     Z.NAME,     C.NAME,     RTRIM(T.GRANTOR),     RTRIM(T.GRANTEE),     CAST('UPDATE' AS VARCHAR(10)),     CASE WHEN T.UPDATEAUTH = 'G' THEN 'YES' ELSE 'NO' END,     CAST( NULL AS VARCHAR(8) )   FROM     SYSIBM.SYSTABAUTH T,     SYSIBM.SYSCOLUMNS C,     SYSIBM.SYSTABLES  Z,     TABLE(SYSPROC.BASE_TABLE(Z.CREATOR, Z.NAME)) AS B   WHERE     T.TCREATOR = C.TBCREATOR     AND T.TTNAME = C.TBNAME     AND T.UPDATEAUTH IN ('Y', 'G')     AND Z.TYPE = 'A'     AND B.BASESCHEMA = T.TCREATOR     AND B.BASENAME = T.TTNAME UNION   SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(Z.CREATOR),     Z.NAME,     C.NAME,     RTRIM(A.GRANTOR),     RTRIM(A.GRANTEE),     CAST('UPDATE' AS VARCHAR(10)),     CASE WHEN A.GRANTABLE = 'G' THEN 'YES' ELSE 'NO' END,     CAST( NULL AS VARCHAR(8) )   FROM     SYSIBM.SYSCOLAUTH A,     SYSIBM.SYSCOLUMNS C,     SYSIBM.SYSTABLES  Z,     TABLE(SYSPROC.BASE_TABLE(Z.CREATOR, Z.NAME)) AS B   WHERE     A.CREATOR = C.TBCREATOR     AND A.TNAME = C.TBNAME     AND A.COLNAME=C.NAME     AND A.PRIVTYPE ='U'     AND Z.TYPE = 'A'     AND B.BASESCHEMA = A.CREATOR     AND B.BASENAME = A.TNAME UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(Z.CREATOR),    Z.NAME,    C.NAME,    RTRIM(GRANTOR),    RTRIM(T.GRANTEE),    CAST('SELECT' AS VARCHAR(10)),    CASE WHEN T.SELECTAUTH='G' THEN 'YES' ELSE 'NO' END,    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH T,    SYSIBM.SYSCOLUMNS C,    SYSIBM.SYSTABLES  Z,    TABLE(SYSPROC.BASE_TABLE(Z.CREATOR, Z.NAME)) AS B  WHERE    T.TCREATOR=C.TBCREATOR    AND T.TTNAME=C.TBNAME    AND T.SELECTAUTH IN ('Y', 'G')    AND Z.TYPE = 'A'    AND B.BASESCHEMA = T.TCREATOR    AND B.BASENAME = T.TTNAME UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(Z.CREATOR),    Z.NAME,    C.NAME,    RTRIM(GRANTOR),    RTRIM(T.GRANTEE),    CAST('INSERT' AS VARCHAR(10)),    CASE WHEN T.INSERTAUTH='G' THEN 'YES' ELSE 'NO' END,    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH T,    SYSIBM.SYSCOLUMNS C,    SYSIBM.SYSTABLES  Z,    TABLE(SYSPROC.BASE_TABLE(Z.CREATOR, Z.NAME)) AS B  WHERE    T.TCREATOR=C.TBCREATOR    AND T.TTNAME=C.TBNAME    AND T.INSERTAUTH IN ('Y', 'G')    AND Z.TYPE = 'A'    AND B.BASESCHEMA = T.TCREATOR    AND B.BASENAME = T.TTNAME;

-- View: SYSIBM.SQLCOLUMNS
CREATE VIEW SYSIBM.SQLCOLUMNS AS CREATE OR REPLACE VIEW SYSIBM.SQLCOLUMNS (  TABLE_CAT,  TABLE_SCHEM,  TABLE_NAME,  COLUMN_NAME,  DATA_TYPE,  TYPE_NAME,  COLUMN_SIZE,  BUFFER_LENGTH,  DECIMAL_DIGITS,  NUM_PREC_RADIX,  NULLABLE,  REMARKS,  COLUMN_DEF,  SQL_DATA_TYPE,  SQL_DATETIME_SUB,  CHAR_OCTET_LENGTH,  ORDINAL_POSITION,  IS_NULLABLE,  JDBC_DATA_TYPE,  SCOPE_CATLOG,  SCOPE_SCHEMA,  SCOPE_TABLE,  SOURCE_DATA_TYPE,  DBNAME,  PSEUDO_COLUMN ) AS  WITH TYPEINTS ( TYPEINT, COLTYPE ) AS (  VALUES  ( SMALLINT(1 ), CHAR( 'INTEGER',  8) ),  ( SMALLINT(2 ), CHAR( 'SMALLINT', 8) ),  ( SMALLINT(3 ), CHAR( 'BIGINT',   8) ),  ( SMALLINT(4 ), CHAR( 'REAL',     8) ),  ( SMALLINT(5 ), CHAR( 'DOUBLE',   8) ),  ( SMALLINT(6 ), CHAR( 'CHAR',     8) ),  ( SMALLINT(7 ), CHAR( 'VARCHAR',  8) ),  ( SMALLINT(8 ), CHAR( 'LONGVAR',  8) ),  ( SMALLINT(9 ), CHAR( 'DECIMAL',  8) ),  ( SMALLINT(10), CHAR( 'GRAPHIC',  8) ),  ( SMALLINT(11), CHAR( 'VARGRAPH', 8) ),  ( SMALLINT(12), CHAR( 'LONGVARG', 8) ),  ( SMALLINT(13), CHAR( 'BLOB',     8) ),  ( SMALLINT(14), CHAR( 'CLOB',     8) ),  ( SMALLINT(15), CHAR( 'DBCLOB',   8) ),  ( SMALLINT(16), CHAR( 'DATE',     8) ),  ( SMALLINT(17), CHAR( 'TIME',     8) ),  ( SMALLINT(18), CHAR( 'TIMESTMP', 8) ),  ( SMALLINT(19), CHAR( 'DATALINK', 8) ),  ( SMALLINT(20), CHAR( 'STRUCT',   8) ),  ( SMALLINT(21), CHAR( 'DISTINCT', 8) ),  ( SMALLINT(22), CHAR( 'REF',      8) ),  ( SMALLINT(23), CHAR( 'XML',      8) ),  ( SMALLINT(25), CHAR( 'BINARY',   8) ),  ( SMALLINT(26), CHAR( 'VARBINAR', 8) ),  ( SMALLINT(27), CHAR( 'BOOLEAN',  8) ) )   SELECT CAST( NULL AS VARCHAR(128) ), RTRIM(C.TBCREATOR), C.TBNAME, C.NAME, SMALLINT( CASE   WHEN I.TYPEINT=1 THEN 4   WHEN I.TYPEINT=2 THEN 5   WHEN I.TYPEINT=3 THEN -5   WHEN I.TYPEINT=4 THEN 7   WHEN I.TYPEINT=5 THEN 8    WHEN I.TYPEINT=6 AND C.CODEPAGE <> 0 then 1   WHEN I.TYPEINT=6 AND C.CODEPAGE = 0 then -2   WHEN I.TYPEINT=7 AND C.CODEPAGE <> 0 THEN 12   WHEN I.TYPEINT=7 AND C.CODEPAGE = 0 THEN -3   WHEN I.TYPEINT=8 AND C.CODEPAGE <> 0 THEN -1   WHEN I.TYPEINT=8 AND C.CODEPAGE = 0 THEN -4   WHEN I.TYPEINT=9 THEN 3   WHEN I.TYPEINT=10 THEN -95   WHEN I.TYPEINT=11 THEN -96   WHEN I.TYPEINT=12 THEN -97   WHEN I.TYPEINT=13 THEN -98   WHEN I.TYPEINT=14 THEN -99   WHEN I.TYPEINT=15 THEN -350   WHEN I.TYPEINT=16 THEN 91   WHEN I.TYPEINT=17 THEN 92   WHEN I.TYPEINT=18 THEN 93   WHEN I.TYPEINT=19 THEN -400   WHEN I.TYPEINT=20 THEN 17   WHEN I.TYPEINT=21 THEN 17   WHEN I.TYPEINT=23 THEN -370   WHEN I.TYPEINT=25 THEN -2   WHEN I.TYPEINT=26 THEN -3   WHEN I.TYPEINT=27 THEN 16   ELSE 0 END),  CAST( CASE   WHEN I.TYPEINT=1 THEN 'INTEGER'   WHEN I.TYPEINT=2 THEN 'SMALLINT'   WHEN I.TYPEINT=3 THEN 'BIGINT'   WHEN I.TYPEINT=4 THEN 'REAL'   WHEN I.TYPEINT=5 THEN 'DOUBLE'   WHEN I.TYPEINT=6 AND C.CODEPAGE <> 0 THEN 'CHAR'   WHEN I.TYPEINT=6 AND C.CODEPAGE = 0 THEN 'CHAR () FOR BIT DATA'   WHEN I.TYPEINT=7 AND C.CODEPAGE <> 0 THEN 'VARCHAR'   WHEN I.TYPEINT=7 AND C.CODEPAGE = 0 THEN 'VARCHAR () FOR BIT DATA'   WHEN I.TYPEINT=8 AND C.CODEPAGE <> 0 THEN 'LONG VARCHAR'   WHEN I.TYPEINT=8 AND C.CODEPAGE = 0 THEN 'LONG VARCHAR FOR BIT DATA'   WHEN I.TYPEINT=9 THEN 'DECIMAL'   WHEN I.TYPEINT=10 THEN 'GRAPHIC'   WHEN I.TYPEINT=11 THEN 'VARGRAPHIC'   WHEN I.TYPEINT=12 THEN 'LONG VARGRAPHIC'   WHEN I.TYPEINT=13 THEN 'BLOB'   WHEN I.TYPEINT=14 THEN 'CLOB'   WHEN I.TYPEINT=15 THEN 'DBCLOB'   WHEN I.TYPEINT=16 THEN 'DATE'   WHEN I.TYPEINT=17 THEN 'TIME'   WHEN I.TYPEINT=18 THEN 'TIMESTAMP'   WHEN I.TYPEINT=19 THEN 'DATALINK'   WHEN I.TYPEINT=20 THEN '"' || RTRIM(D.SCHEMA) || '"."' || D.NAME || '"'   WHEN I.TYPEINT=21 THEN '"' || RTRIM(D.SCHEMA) || '"."' || D.NAME || '"'   WHEN I.TYPEINT=23 THEN 'XML'   WHEN I.TYPEINT=25 THEN 'BINARY'   WHEN I.TYPEINT=26 THEN 'VARBINARY'   WHEN I.TYPEINT=27 THEN 'BOOLEAN'   ELSE '' END AS VARCHAR(261) ),  CASE   WHEN I.TYPEINT=1 THEN 10   WHEN I.TYPEINT=2 THEN 5   WHEN I.TYPEINT=3 THEN 19   WHEN I.TYPEINT=4 THEN 24   WHEN I.TYPEINT=5 THEN 53   WHEN I.TYPEINT=6 THEN C.LENGTH   WHEN I.TYPEINT=7 THEN C.LENGTH   WHEN I.TYPEINT=8 THEN C.LENGTH   WHEN I.TYPEINT=9 THEN C.LENGTH   WHEN I.TYPEINT=10 THEN C.LENGTH   WHEN I.TYPEINT=11 THEN C.LENGTH   WHEN I.TYPEINT=12 THEN C.LENGTH   WHEN I.TYPEINT=13 THEN C.LONGLENGTH   WHEN I.TYPEINT=14 THEN C.LONGLENGTH   WHEN I.TYPEINT=15 THEN C.LONGLENGTH   WHEN I.TYPEINT=16 THEN 10   WHEN I.TYPEINT=17 THEN 8    WHEN I.TYPEINT=18 THEN    CASE WHEN C.SCALE=0 THEN 19         ELSE 20+C.SCALE    END   WHEN I.TYPEINT=20 THEN D.LENGTH   WHEN I.TYPEINT=21 THEN D.LENGTH   WHEN I.TYPEINT=23 THEN C.LONGLENGTH   WHEN I.TYPEINT=27 THEN 1   ELSE C.LENGTH END,  CASE   WHEN I.TYPEINT=1 THEN 4   WHEN I.TYPEINT=2 THEN 2   WHEN I.TYPEINT=3 THEN 8   WHEN I.TYPEINT=4 THEN 4   WHEN I.TYPEINT=5 THEN 8   WHEN I.TYPEINT=6 THEN C.LENGTH   WHEN I.TYPEINT=7 THEN C.LENGTH   WHEN I.TYPEINT=8 THEN C.LENGTH   WHEN I.TYPEINT=9 THEN C.LENGTH + 2   WHEN I.TYPEINT=10 THEN C.LENGTH * 2   WHEN I.TYPEINT=11 THEN C.LENGTH * 2   WHEN I.TYPEINT=12 THEN C.LENGTH * 2   WHEN I.TYPEINT=13 THEN C.LONGLENGTH   WHEN I.TYPEINT=14 THEN C.LONGLENGTH   WHEN I.TYPEINT=15 THEN C.LONGLENGTH * 2   WHEN I.TYPEINT=16 THEN 6   WHEN I.TYPEINT=17 THEN 6   WHEN I.TYPEINT=18 THEN 16   WHEN I.TYPEINT=19 THEN C.LENGTH   WHEN I.TYPEINT=20        AND D.SOURCETYPE          NOT IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')        THEN D.LENGTH   WHEN I.TYPEINT=20        AND D.SOURCETYPE          IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')        THEN D.LENGTH * 2   WHEN I.TYPEINT=21        AND D.SOURCETYPE          NOT IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')        THEN D.LENGTH   WHEN I.TYPEINT=21        AND D.SOURCETYPE          IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')        THEN D.LENGTH * 2    WHEN I.TYPEINT=23 THEN C.LONGLENGTH   WHEN I.TYPEINT=27 THEN 1   ELSE C.LENGTH END,  SMALLINT( CASE   WHEN I.TYPEINT=1 THEN 0   WHEN I.TYPEINT=2 THEN 0   WHEN I.TYPEINT=3 THEN 0   WHEN I.TYPEINT=4 THEN NULL   WHEN I.TYPEINT=5 THEN NULL   WHEN I.TYPEINT=6 THEN NULL   WHEN I.TYPEINT=7 THEN NULL   WHEN I.TYPEINT=8 THEN NULL   WHEN I.TYPEINT=9 THEN C.SCALE   WHEN I.TYPEINT=10 THEN NULL   WHEN I.TYPEINT=11 THEN NULL   WHEN I.TYPEINT=12 THEN NULL   WHEN I.TYPEINT=13 THEN NULL   WHEN I.TYPEINT=14 THEN NULL   WHEN I.TYPEINT=15 THEN NULL   WHEN I.TYPEINT=16 THEN NULL   WHEN I.TYPEINT=17 THEN 0   WHEN I.TYPEINT=18 THEN C.SCALE   WHEN I.TYPEINT=19 THEN NULL   WHEN I.TYPEINT=20         AND D.SOURCETYPE='DECIMAL'        THEN D.SCALE   WHEN I.TYPEINT=20        AND D.SOURCETYPE IN ('INTEGER','SMALLINT','BIGINT','TIME')        THEN 0   WHEN I.TYPEINT=20        AND D.SOURCETYPE='TIMESTAMP'        THEN D.SCALE    WHEN I.TYPEINT=21        AND D.SOURCETYPE='DECIMAL'        THEN D.SCALE    WHEN I.TYPEINT=21        AND D.SOURCETYPE IN ('INTEGER','SMALLINT','BIGINT','TIME')        THEN 0    WHEN I.TYPEINT=21        AND D.SOURCETYPE='TIMESTAMP'        THEN D.SCALE   WHEN I.TYPEINT=23 THEN NULL   WHEN I.TYPEINT=27 THEN 0   ELSE NULL END ),     SMALLINT(CASE   WHEN I.TYPEINT=1 THEN 10    WHEN I.TYPEINT=2 THEN 10   WHEN I.TYPEINT=3 THEN 10   WHEN I.TYPEINT=4 THEN 2   WHEN I.TYPEINT=5 THEN 2   WHEN I.TYPEINT=6 THEN NULL   WHEN I.TYPEINT=7 THEN NULL   WHEN I.TYPEINT=8 THEN NULL   WHEN I.TYPEINT=9 THEN 10   WHEN I.TYPEINT=10 THEN NULL   WHEN I.TYPEINT=11 THEN NULL   WHEN I.TYPEINT=12 THEN NULL   WHEN I.TYPEINT=13 THEN NULL   WHEN I.TYPEINT=14 THEN NULL   WHEN I.TYPEINT=15 THEN NULL   WHEN I.TYPEINT=16 THEN NULL   WHEN I.TYPEINT=17 THEN NULL   WHEN I.TYPEINT=18 THEN NULL   WHEN I.TYPEINT=19 THEN NULL   WHEN I.TYPEINT=20        AND D.SOURCETYPE IN ('DECIMAL','INTEGER','SMALLINT','BIGINT')        THEN 10   WHEN I.TYPEINT=20        AND D.SOURCETYPE IN ('REAL','FLOAT','DOUBLE')        THEN 2   WHEN I.TYPEINT=21        AND D.SOURCETYPE IN ('DECIMAL','INTEGER','SMALLINT','BIGINT')        THEN 10   WHEN I.TYPEINT=21         AND D.SOURCETYPE IN ('REAL','FLOAT','DOUBLE')        THEN 2   WHEN I.TYPEINT=23 THEN NULL   WHEN I.TYPEINT=27 THEN 1   ELSE NULL END),    SMALLINT(CASE    WHEN C.NULLS='Y' THEN 1 ELSE 0 END), C.REMARKS, C.DEFAULT, SMALLINT(CASE   WHEN I.TYPEINT=1 THEN 4   WHEN I.TYPEINT=2 THEN 5    WHEN I.TYPEINT=3 THEN -5   WHEN I.TYPEINT=4 THEN 7   WHEN I.TYPEINT=5 THEN 8   WHEN I.TYPEINT=6 AND C.CODEPAGE <> 0 then 1    WHEN I.TYPEINT=6 AND C.CODEPAGE = 0 then -2    WHEN I.TYPEINT=7 AND C.CODEPAGE <> 0 THEN 12   WHEN I.TYPEINT=7 AND C.CODEPAGE = 0 THEN -3   WHEN I.TYPEINT=8 AND C.CODEPAGE <> 0 THEN -1   WHEN I.TYPEINT=8 AND C.CODEPAGE = 0 THEN -4   WHEN I.TYPEINT=9 THEN 3   WHEN I.TYPEINT=10 THEN -95   WHEN I.TYPEINT=11 THEN -96   WHEN I.TYPEINT=12 THEN -97   WHEN I.TYPEINT=13 THEN -98   WHEN I.TYPEINT=14 THEN -99   WHEN I.TYPEINT=15 THEN -350   WHEN I.TYPEINT=16 THEN 9   WHEN I.TYPEINT=17 THEN 9   WHEN I.TYPEINT=18 THEN 9   WHEN I.TYPEINT=19 THEN -400   WHEN I.TYPEINT=20 THEN 17   WHEN I.TYPEINT=21 THEN 17   WHEN I.TYPEINT=23 THEN -370   WHEN I.TYPEINT=25 THEN -2   WHEN I.TYPEINT=26 THEN -3   WHEN I.TYPEINT=27 THEN 16   ELSE 0 END),    SMALLINT(CASE   WHEN I.TYPEINT=1 THEN NULL   WHEN I.TYPEINT=2 THEN NULL   WHEN I.TYPEINT=3 THEN NULL   WHEN I.TYPEINT=4 THEN NULL   WHEN I.TYPEINT=5 THEN NULL   WHEN I.TYPEINT=6 THEN NULL   WHEN I.TYPEINT=7 THEN NULL   WHEN I.TYPEINT=8 THEN NULL   WHEN I.TYPEINT=9 THEN NULL   WHEN I.TYPEINT=10 THEN NULL   WHEN I.TYPEINT=11 THEN NULL   WHEN I.TYPEINT=12 THEN NULL   WHEN I.TYPEINT=13 THEN NULL   WHEN I.TYPEINT=14 THEN NULL   WHEN I.TYPEINT=15 THEN NULL   WHEN I.TYPEINT=16 THEN 1   WHEN I.TYPEINT=17 THEN 2   WHEN I.TYPEINT=18 THEN 3   WHEN I.TYPEINT=19 THEN NULL   WHEN I.TYPEINT=20        AND D.SOURCETYPE='DATE' THEN 1   WHEN I.TYPEINT=20        AND D.SOURCETYPE='TIME' THEN 2   WHEN I.TYPEINT=20        AND D.SOURCETYPE='TIMESTAMP' THEN 3   WHEN I.TYPEINT=21        AND D.SOURCETYPE='DATE' THEN 1    WHEN I.TYPEINT=21        AND D.SOURCETYPE='TIME' THEN 2   WHEN I.TYPEINT=21        AND D.SOURCETYPE='TIMESTAMP' THEN 3   WHEN I.TYPEINT=23 THEN NULL   ELSE NULL END),     CASE WHEN I.TYPEINT=1 THEN NULL WHEN I.TYPEINT=2 THEN NULL WHEN I.TYPEINT=3 THEN NULL WHEN I.TYPEINT=4 THEN NULL WHEN I.TYPEINT=5 THEN NULL WHEN I.TYPEINT=6 THEN C.LENGTH WHEN I.TYPEINT=7 THEN C.LENGTH WHEN I.TYPEINT=8 THEN C.LENGTH WHEN I.TYPEINT=9 THEN NULL WHEN I.TYPEINT=10 THEN C.LENGTH * 2 WHEN I.TYPEINT=11 THEN C.LENGTH * 2 WHEN I.TYPEINT=12 THEN C.LENGTH * 2 WHEN I.TYPEINT=13 THEN C.LONGLENGTH WHEN I.TYPEINT=14 THEN C.LONGLENGTH WHEN I.TYPEINT=15 THEN C.LONGLENGTH * 2  WHEN I.TYPEINT=16 THEN NULL WHEN I.TYPEINT=17 THEN NULL WHEN I.TYPEINT=18 THEN NULL WHEN I.TYPEINT=19 THEN NULL WHEN I.TYPEINT=20      AND D.SOURCETYPE IN      ('CHARACTER','VARCHAR','LONG VARCHAR', 'BINARY', 'VARBINARY', 'BLOB','CLOB')      THEN D.LENGTH WHEN I.TYPEINT=20      AND D.SOURCETYPE IN      ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')      THEN D.LENGTH * 2 WHEN I.TYPEINT=21      AND D.SOURCETYPE IN      ('CHARACTER','VARCHAR','LONG VARCHAR', 'BINARY', 'VARBINARY', 'BLOB','CLOB')      THEN D.LENGTH    WHEN I.TYPEINT=21        AND D.SOURCETYPE IN        ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')        THEN D.LENGTH * 2   WHEN I.TYPEINT=23 THEN C.LONGLENGTH   WHEN I.TYPEINT=25 THEN C.LENGTH   WHEN I.TYPEINT=26 THEN C.LENGTH   ELSE NULL END, C.COLNO + 1, CASE   WHEN C.NULLS='Y' THEN 'YES' ELSE 'NO' END, SMALLINT( CASE   WHEN I.TYPEINT=1 THEN 4   WHEN I.TYPEINT=2 THEN 5   WHEN I.TYPEINT=3 THEN -5   WHEN I.TYPEINT=4 THEN 7   WHEN I.TYPEINT=5 THEN 8   WHEN I.TYPEINT=6 AND C.CODEPAGE <> 0 then 1   WHEN I.TYPEINT=6 AND C.CODEPAGE = 0 then -2   WHEN I.TYPEINT=7 AND C.CODEPAGE <> 0 THEN 12   WHEN I.TYPEINT=7 AND C.CODEPAGE = 0 THEN -3   WHEN I.TYPEINT=8 AND C.CODEPAGE <> 0 THEN -1   WHEN I.TYPEINT=8 AND C.CODEPAGE = 0 THEN -4   WHEN I.TYPEINT=9 THEN 3   WHEN I.TYPEINT=10 THEN 1   WHEN I.TYPEINT=11 THEN 12   WHEN I.TYPEINT=12 THEN -1   WHEN I.TYPEINT=13 THEN 2004   WHEN I.TYPEINT=14 THEN 2005   WHEN I.TYPEINT=15 THEN 2005   WHEN I.TYPEINT=16 THEN 91  WHEN I.TYPEINT=17 THEN 92   WHEN I.TYPEINT=18 THEN 93   WHEN I.TYPEINT=19 THEN 70   WHEN I.TYPEINT=20 THEN 2002   WHEN I.TYPEINT=21 THEN 2001   WHEN I.TYPEINT=23 THEN 1111   WHEN I.TYPEINT=25 THEN -2   WHEN I.TYPEINT=26 THEN -3   WHEN I.TYPEINT=27 THEN 16   ELSE 0 END), CAST( NULL AS VARCHAR(128) ), CAST( NULL AS VARCHAR(128) ), CAST( NULL AS VARCHAR(128) ), SMALLINT( CASE   WHEN D.SOURCETYPE IS NULL THEN NULL   WHEN D.SOURCETYPE='INTEGER' THEN 4   WHEN D.SOURCETYPE='SMALLINT' THEN 5   WHEN D.SOURCETYPE='BIGINT' THEN -5   WHEN D.SOURCETYPE='FLOAT' AND C.LENGTH=4 THEN 7   WHEN D.SOURCETYPE='FLOAT' AND C.LENGTH=8 THEN 8   WHEN D.SOURCETYPE='REAL' THEN 7   WHEN D.SOURCETYPE='DOUBLE' THEN 8   WHEN D.SOURCETYPE='CHARACTER' AND C.CODEPAGE <> 0 then 1   WHEN D.SOURCETYPE='CHARACTER' AND C.CODEPAGE = 0 then -2   WHEN D.SOURCETYPE='VARCHAR' AND C.CODEPAGE <> 0 THEN 12   WHEN D.SOURCETYPE='VARCHAR' AND C.CODEPAGE = 0 THEN -3   WHEN D.SOURCETYPE='LONG VARCHAR' AND C.CODEPAGE <> 0 THEN -1   WHEN D.SOURCETYPE='LONG VARCHAR' AND C.CODEPAGE = 0 THEN -4   WHEN D.SOURCETYPE='DECIMAL' THEN 3   WHEN D.SOURCETYPE='GRAPHIC' THEN -95   WHEN D.SOURCETYPE='VARGRAPHIC' THEN -96   WHEN D.SOURCETYPE='LONG VARGRAPHIC' THEN -97   WHEN D.SOURCETYPE='BLOB' THEN -98   WHEN D.SOURCETYPE='CLOB' THEN -99   WHEN D.SOURCETYPE='DBCLOB' THEN -350   WHEN D.SOURCETYPE='DATE' THEN 91   WHEN D.SOURCETYPE='TIME' THEN 92   WHEN D.SOURCETYPE='TIMESTAMP' THEN 93   WHEN D.SOURCETYPE='DATALINK' THEN -400   WHEN D.SOURCETYPE='XML' THEN -370   WHEN D.SOURCETYPE='BINARY' THEN -2   WHEN D.SOURCETYPE='VARBINARY' THEN -3   WHEN D.SOURCETYPE='BOOLEAN' THEN 16   ELSE 0     END), CAST( NULL AS VARCHAR(8) ), SMALLINT(CASE   WHEN C.IDENTITY = 'Y' THEN 2   ELSE 1 END )  FROM   SYSCAT.SYSCOLUMNS_UNION C,   SYSCAT.SYSDATATYPES_UNION D,   TYPEINTS I WHERE   C.COLTYPE <> 'REF'   AND I.TYPEINT <> 22   AND C.TYPENAME = D.NAME   AND C.TYPESCHEMA = D.SCHEMA   AND C.COLTYPE = I.COLTYPE    UNION ALL SELECT   CAST( NULL AS VARCHAR(128) ),   RTRIM(C.TBCREATOR),   C.TBNAME,   C.NAME,   SMALLINT(20),   CAST( '"' || RTRIM(D.SCHEMA) || '"."' || D.NAME || '"'         AS VARCHAR(261) ),   CASE     WHEN D.SOURCETYPE = 'REAL' THEN 24     WHEN D.SOURCETYPE = 'DOUBLE' THEN 53     ELSE D.LENGTH   END,   CASE     WHEN D.SOURCETYPE            NOT IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')          THEN D.LENGTH     WHEN D.SOURCETYPE            IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')          THEN D.LENGTH * 2     ELSE NULL   END,   SMALLINT( CASE     WHEN D.SOURCETYPE='DECIMAL'          THEN D.SCALE     WHEN D.SOURCETYPE IN ('INTEGER','SMALLINT','BIGINT','TIME')          THEN 0     WHEN D.SOURCETYPE='TIMESTAMP'          THEN 6     ELSE NULL   END ),   SMALLINT( CASE     WHEN D.SOURCETYPE IN ('DECIMAL','INTEGER','SMALLINT','BIGINT')          THEN 10     WHEN D.SOURCETYPE IN ('REAL','FLOAT','DOUBLE')          THEN 2     ELSE NULL   END),    SMALLINT(CASE    WHEN C.NULLS='Y' THEN 1 ELSE 0 END), C.REMARKS, C.DEFAULT, SMALLINT( 20 ), SMALLINT( CASE   WHEN D.SOURCETYPE='DATE' THEN 1   WHEN D.SOURCETYPE='TIME' THEN 2   WHEN D.SOURCETYPE='TIMESTAMP' THEN 3   ELSE NULL END), CASE   WHEN D.SOURCETYPE IN        ('CHARACTER','VARCHAR', 'LONG VARCHAR', 'BINARY', 'VARBINARY', 'BLOB','CLOB','XML')        THEN D.LENGTH   WHEN D.SOURCETYPE IN        ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')        THEN D.LENGTH * 2   ELSE NULL END, C.COLNO + 1, CASE   WHEN C.NULLS='Y' THEN 'YES' ELSE 'NO' END, SMALLINT( 2006 ), CAST( NULL AS VARCHAR(128) ), CAST( NULL AS VARCHAR(128) ), CAST( NULL AS VARCHAR(128) ), SMALLINT( CASE   WHEN D.SOURCETYPE IS NULL THEN NULL   WHEN D.SOURCETYPE='INTEGER' THEN 4   WHEN D.SOURCETYPE='SMALLINT' THEN 5   WHEN D.SOURCETYPE='BIGINT' THEN -5   WHEN D.SOURCETYPE='FLOAT' AND C.LENGTH=4 THEN 7   WHEN D.SOURCETYPE='FLOAT' AND C.LENGTH=8 THEN 8   WHEN D.SOURCETYPE='REAL' THEN 7   WHEN D.SOURCETYPE='DOUBLE' THEN 8   WHEN D.SOURCETYPE='CHARACTER' AND C.CODEPAGE <> 0 then 1   WHEN D.SOURCETYPE='CHARACTER' AND C.CODEPAGE = 0 then -2   WHEN D.SOURCETYPE='VARCHAR' AND C.CODEPAGE <> 0 THEN 12   WHEN D.SOURCETYPE='VARCHAR' AND C.CODEPAGE = 0 THEN -3   WHEN D.SOURCETYPE='LONG VARCHAR' AND C.CODEPAGE <> 0 THEN -1   WHEN D.SOURCETYPE='LONG VARCHAR' AND C.CODEPAGE = 0 THEN -4   WHEN D.SOURCETYPE='DECIMAL' THEN 3   WHEN D.SOURCETYPE='GRAPHIC' THEN -95   WHEN D.SOURCETYPE='VARGRAPHIC' THEN -96   WHEN D.SOURCETYPE='LONG VARGRAPHIC' THEN -97   WHEN D.SOURCETYPE='BLOB' THEN -98   WHEN D.SOURCETYPE='CLOB' THEN -99   WHEN D.SOURCETYPE='DBCLOB' THEN -350   WHEN D.SOURCETYPE='DATE' THEN 91   WHEN D.SOURCETYPE='TIME' THEN 92   WHEN D.SOURCETYPE='TIMESTAMP' THEN 93   WHEN D.SOURCETYPE='DATALINK' THEN -400   WHEN D.SOURCETYPE='XML' THEN -370   WHEN D.SOURCETYPE='BINARY' THEN -2   WHEN D.SOURCETYPE='VARBINARY' THEN -3   WHEN D.SOURCETYPE='BOOLEAN' THEN 16   ELSE 0 END ), CAST( NULL AS VARCHAR(8) ), SMALLINT(1) FROM   SYSCAT.SYSCOLUMNS_UNION C,   SYSCAT.SYSDATATYPES_UNION D,   SYSCAT.SYSCOLPROPERTIES_UNION P,   TYPEINTS I WHERE   C.COLTYPE = 'REF'   AND I.TYPEINT = 22   AND P.COLNAME = C.NAME   AND P.TABSCHEMA = C.TBCREATOR    AND P.TABNAME = C.TBNAME   AND P.TARGET_TYPENAME = D.NAME   AND P.TARGET_TYPESCHEMA = D.SCHEMA   AND C.COLTYPE = I.COLTYPE  UNION ALL  SELECT CAST( NULL AS VARCHAR(128) ), RTRIM(T.CREATOR), T.NAME, C.NAME, SMALLINT( CASE   WHEN I.TYPEINT=1 THEN 4   WHEN I.TYPEINT=2 THEN 5   WHEN I.TYPEINT=3 THEN -5   WHEN I.TYPEINT=4 THEN 7   WHEN I.TYPEINT=5 THEN 8   WHEN I.TYPEINT=6 AND C.CODEPAGE <> 0 then 1   WHEN I.TYPEINT=6 AND C.CODEPAGE = 0 then -2   WHEN I.TYPEINT=7 AND C.CODEPAGE <> 0 THEN 12   WHEN I.TYPEINT=7 AND C.CODEPAGE = 0 THEN -3   WHEN I.TYPEINT=8 AND C.CODEPAGE <> 0 THEN -1   WHEN I.TYPEINT=8 AND C.CODEPAGE = 0 THEN -4   WHEN I.TYPEINT=9 THEN 3   WHEN I.TYPEINT=10 THEN -95   WHEN I.TYPEINT=11 THEN -96   WHEN I.TYPEINT=12 THEN -97   WHEN I.TYPEINT=13 THEN -98   WHEN I.TYPEINT=14 THEN -99   WHEN I.TYPEINT=15 THEN -350   WHEN I.TYPEINT=16 THEN 91   WHEN I.TYPEINT=17 THEN 92   WHEN I.TYPEINT=18 THEN 93   WHEN I.TYPEINT=19 THEN -400   WHEN I.TYPEINT=20 THEN 17   WHEN I.TYPEINT=21 THEN 17   WHEN I.TYPEINT=23 THEN -370   ELSE 0 END),    CAST( CASE   WHEN I.TYPEINT=1 THEN 'INTEGER'   WHEN I.TYPEINT=2 THEN 'SMALLINT'   WHEN I.TYPEINT=3 THEN 'BIGINT'   WHEN I.TYPEINT=4 THEN 'REAL'   WHEN I.TYPEINT=5 THEN 'DOUBLE'   WHEN I.TYPEINT=6 AND C.CODEPAGE <> 0 THEN 'CHAR'   WHEN I.TYPEINT=6 AND C.CODEPAGE = 0 THEN 'CHAR () FOR BIT DATA'   WHEN I.TYPEINT=7 AND C.CODEPAGE <> 0 THEN 'VARCHAR'   WHEN I.TYPEINT=7 AND C.CODEPAGE = 0 THEN 'VARCHAR () FOR BIT DATA'   WHEN I.TYPEINT=8 AND C.CODEPAGE <> 0 THEN 'LONG VARCHAR'   WHEN I.TYPEINT=8 AND C.CODEPAGE = 0 THEN 'LONG VARCHAR FOR BIT DATA'   WHEN I.TYPEINT=9 THEN 'DECIMAL'   WHEN I.TYPEINT=10 THEN 'GRAPHIC'   WHEN I.TYPEINT=11 THEN 'VARGRAPHIC'   WHEN I.TYPEINT=12 THEN 'LONG VARGRAPHIC'   WHEN I.TYPEINT=13 THEN 'BLOB'   WHEN I.TYPEINT=14 THEN 'CLOB'   WHEN I.TYPEINT=15 THEN 'DBCLOB'   WHEN I.TYPEINT=16 THEN 'DATE'   WHEN I.TYPEINT=17 THEN 'TIME'   WHEN I.TYPEINT=18 THEN 'TIMESTAMP'   WHEN I.TYPEINT=19 THEN 'DATALINK'   WHEN I.TYPEINT=20 THEN '"' || RTRIM(D.SCHEMA) || '"."' || D.NAME || '"'   WHEN I.TYPEINT=21 THEN '"' || RTRIM(D.SCHEMA) || '"."' || D.NAME || '"'   WHEN I.TYPEINT=23 THEN 'XML'   WHEN I.TYPEINT=25 THEN 'BINARY'   WHEN I.TYPEINT=26 THEN 'VARBINARY'  ELSE '' END  AS VARCHAR(261) ),  CASE   WHEN I.TYPEINT=1 THEN 10   WHEN I.TYPEINT=2 THEN 5   WHEN I.TYPEINT=3 THEN 19    WHEN I.TYPEINT=4 THEN 24   WHEN I.TYPEINT=5 THEN 53   WHEN I.TYPEINT=6 THEN C.LENGTH   WHEN I.TYPEINT=7 THEN C.LENGTH   WHEN I.TYPEINT=8 THEN C.LENGTH   WHEN I.TYPEINT=9 THEN C.LENGTH   WHEN I.TYPEINT=10 THEN C.LENGTH   WHEN I.TYPEINT=11 THEN C.LENGTH   WHEN I.TYPEINT=12 THEN C.LENGTH   WHEN I.TYPEINT=13 THEN C.LONGLENGTH   WHEN I.TYPEINT=14 THEN C.LONGLENGTH   WHEN I.TYPEINT=15 THEN C.LONGLENGTH   WHEN I.TYPEINT=16 THEN 10   WHEN I.TYPEINT=17 THEN 8    WHEN I.TYPEINT=18 THEN    CASE WHEN C.SCALE=0 THEN 19         ELSE 20+C.SCALE    END   WHEN I.TYPEINT=20 THEN D.LENGTH   WHEN I.TYPEINT=21 THEN D.LENGTH   WHEN I.TYPEINT=23 THEN C.LONGLENGTH   WHEN I.TYPEINT=25 THEN C.LENGTH   WHEN I.TYPEINT=26 THEN C.LENGTH  ELSE C.LENGTH END,  CASE WHEN I.TYPEINT=1 THEN 4 WHEN I.TYPEINT=2 THEN 2 WHEN I.TYPEINT=3 THEN 8 WHEN I.TYPEINT=4 THEN 4 WHEN I.TYPEINT=5 THEN 8 WHEN I.TYPEINT=6 THEN C.LENGTH WHEN I.TYPEINT=7 THEN C.LENGTH WHEN I.TYPEINT=8 THEN C.LENGTH WHEN I.TYPEINT=9 THEN C.LENGTH + 2 WHEN I.TYPEINT=10 THEN C.LENGTH * 2 WHEN I.TYPEINT=11 THEN C.LENGTH * 2 WHEN I.TYPEINT=12 THEN C.LENGTH * 2 WHEN I.TYPEINT=13 THEN C.LONGLENGTH WHEN I.TYPEINT=14 THEN C.LONGLENGTH WHEN I.TYPEINT=15 THEN C.LONGLENGTH * 2 WHEN I.TYPEINT=16 THEN 6 WHEN I.TYPEINT=17 THEN 6 WHEN I.TYPEINT=18 THEN 16 WHEN I.TYPEINT=19 THEN C.LENGTH WHEN I.TYPEINT=20      AND D.SOURCETYPE        NOT IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')      THEN D.LENGTH WHEN I.TYPEINT=20      AND D.SOURCETYPE        IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')      THEN D.LENGTH * 2 WHEN I.TYPEINT=21      AND D.SOURCETYPE        NOT IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')      THEN D.LENGTH  WHEN I.TYPEINT=21        AND D.SOURCETYPE          IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')        THEN D.LENGTH * 2 WHEN I.TYPEINT=23 THEN C.LONGLENGTH   ELSE C.LENGTH END, SMALLINT( CASE   WHEN I.TYPEINT=1 THEN 0   WHEN I.TYPEINT=2 THEN 0   WHEN I.TYPEINT=3 THEN 0   WHEN I.TYPEINT=4 THEN NULL   WHEN I.TYPEINT=5 THEN NULL   WHEN I.TYPEINT=6 THEN NULL   WHEN I.TYPEINT=7 THEN NULL   WHEN I.TYPEINT=8 THEN NULL   WHEN I.TYPEINT=9 THEN C.SCALE   WHEN I.TYPEINT=10 THEN NULL   WHEN I.TYPEINT=11 THEN NULL   WHEN I.TYPEINT=12 THEN NULL   WHEN I.TYPEINT=13 THEN NULL   WHEN I.TYPEINT=14 THEN NULL   WHEN I.TYPEINT=15 THEN NULL   WHEN I.TYPEINT=16 THEN NULL    WHEN I.TYPEINT=17 THEN 0   WHEN I.TYPEINT=18 THEN C.SCALE   WHEN I.TYPEINT=19 THEN NULL   WHEN I.TYPEINT=20        AND D.SOURCETYPE='DECIMAL'        THEN D.SCALE   WHEN I.TYPEINT=20        AND D.SOURCETYPE IN ('INTEGER','SMALLINT','BIGINT','TIME')        THEN 0  WHEN I.TYPEINT=20        AND D.SOURCETYPE='TIMESTAMP'        THEN D.SCALE   WHEN I.TYPEINT=21        AND D.SOURCETYPE='DECIMAL'        THEN D.SCALE   WHEN I.TYPEINT=21        AND D.SOURCETYPE IN ('INTEGER','SMALLINT','BIGINT','TIME')        THEN 0   WHEN I.TYPEINT=21        AND D.SOURCETYPE='TIMESTAMP'        THEN D.SCALE   WHEN I.TYPEINT=23 THEN NULL   ELSE NULL END ), SMALLINT(CASE   WHEN I.TYPEINT=1 THEN 10   WHEN I.TYPEINT=2 THEN 10   WHEN I.TYPEINT=3 THEN 10   WHEN I.TYPEINT=4 THEN 2   WHEN I.TYPEINT=5 THEN 2   WHEN I.TYPEINT=6 THEN NULL   WHEN I.TYPEINT=7 THEN NULL   WHEN I.TYPEINT=8 THEN NULL   WHEN I.TYPEINT=9 THEN 10   WHEN I.TYPEINT=10 THEN NULL   WHEN I.TYPEINT=11 THEN NULL   WHEN I.TYPEINT=12 THEN NULL   WHEN I.TYPEINT=13 THEN NULL   WHEN I.TYPEINT=14 THEN NULL   WHEN I.TYPEINT=15 THEN NULL   WHEN I.TYPEINT=16 THEN NULL   WHEN I.TYPEINT=17 THEN NULL   WHEN I.TYPEINT=18 THEN NULL   WHEN I.TYPEINT=19 THEN NULL  WHEN I.TYPEINT=20         AND D.SOURCETYPE IN ('DECIMAL','INTEGER','SMALLINT','BIGINT')         THEN 10    WHEN I.TYPEINT=20         AND D.SOURCETYPE IN ('REAL','FLOAT','DOUBLE')         THEN 2    WHEN I.TYPEINT=21         AND D.SOURCETYPE IN ('DECIMAL','INTEGER','SMALLINT','BIGINT')         THEN 10    WHEN I.TYPEINT=21         AND D.SOURCETYPE IN ('REAL','FLOAT','DOUBLE')         THEN 2    WHEN I.TYPEINT=23 THEN NULL    ELSE NULL  END),  SMALLINT(CASE     WHEN C.NULLS='Y' THEN 1 ELSE 0  END),  C.REMARKS,  C.DEFAULT,  SMALLINT(CASE    WHEN I.TYPEINT=1 THEN 4    WHEN I.TYPEINT=2 THEN 5    WHEN I.TYPEINT=3 THEN -5    WHEN I.TYPEINT=4 THEN 7    WHEN I.TYPEINT=5 THEN 8     WHEN I.TYPEINT=6 AND C.CODEPAGE <> 0 then 1    WHEN I.TYPEINT=6 AND C.CODEPAGE = 0 then -2    WHEN I.TYPEINT=7 AND C.CODEPAGE <> 0 THEN 12    WHEN I.TYPEINT=7 AND C.CODEPAGE = 0 THEN -3    WHEN I.TYPEINT=8 AND C.CODEPAGE <> 0 THEN -1    WHEN I.TYPEINT=8 AND C.CODEPAGE = 0 THEN -4    WHEN I.TYPEINT=9 THEN 3  WHEN I.TYPEINT=10 THEN -95   WHEN I.TYPEINT=11 THEN -96   WHEN I.TYPEINT=12 THEN -97   WHEN I.TYPEINT=13 THEN -98   WHEN I.TYPEINT=14 THEN -99   WHEN I.TYPEINT=15 THEN -350   WHEN I.TYPEINT=16 THEN 9   WHEN I.TYPEINT=17 THEN 9   WHEN I.TYPEINT=18 THEN 9   WHEN I.TYPEINT=19 THEN -400   WHEN I.TYPEINT=20 THEN 17   WHEN I.TYPEINT=21 THEN 17   WHEN I.TYPEINT=23 THEN -370   WHEN I.TYPEINT=25 THEN -2   WHEN I.TYPEINT=26 THEN -3   ELSE 0 END), SMALLINT(CASE   WHEN I.TYPEINT=1 THEN NULL   WHEN I.TYPEINT=2 THEN NULL   WHEN I.TYPEINT=3 THEN NULL   WHEN I.TYPEINT=4 THEN NULL   WHEN I.TYPEINT=5 THEN NULL   WHEN I.TYPEINT=6 THEN NULL   WHEN I.TYPEINT=7 THEN NULL   WHEN I.TYPEINT=8 THEN NULL   WHEN I.TYPEINT=9 THEN NULL   WHEN I.TYPEINT=10 THEN NULL   WHEN I.TYPEINT=11 THEN NULL   WHEN I.TYPEINT=12 THEN NULL   WHEN I.TYPEINT=13 THEN NULL   WHEN I.TYPEINT=14 THEN NULL   WHEN I.TYPEINT=15 THEN NULL   WHEN I.TYPEINT=16 THEN 1   WHEN I.TYPEINT=17 THEN 2   WHEN I.TYPEINT=18 THEN 3   WHEN I.TYPEINT=19 THEN NULL  WHEN I.TYPEINT=20        AND D.SOURCETYPE='DATE' THEN 1   WHEN I.TYPEINT=20        AND D.SOURCETYPE='TIME' THEN 2   WHEN I.TYPEINT=20        AND D.SOURCETYPE='TIMESTAMP' THEN 3   WHEN I.TYPEINT=21        AND D.SOURCETYPE='DATE' THEN 1   WHEN I.TYPEINT=21        AND D.SOURCETYPE='TIME' THEN 2   WHEN I.TYPEINT=21        AND D.SOURCETYPE='TIMESTAMP' THEN 3   WHEN I.TYPEINT=23 THEN NULL   ELSE NULL END), CASE    WHEN I.TYPEINT=6 THEN C.LENGTH   WHEN I.TYPEINT=7 THEN C.LENGTH   WHEN I.TYPEINT=8 THEN C.LENGTH   WHEN I.TYPEINT=10 THEN C.LENGTH * 2   WHEN I.TYPEINT=11 THEN C.LENGTH * 2   WHEN I.TYPEINT=12 THEN C.LENGTH * 2   WHEN I.TYPEINT=13 THEN C.LONGLENGTH   WHEN I.TYPEINT=14 THEN C.LONGLENGTH   WHEN I.TYPEINT=15 THEN C.LONGLENGTH * 2   WHEN I.TYPEINT=20        AND D.SOURCETYPE IN        ('CHARACTER','VARCHAR','LONG VARCHAR','BINARY', 'VARBINARY', 'BLOB','CLOB','XML')        THEN D.LENGTH       WHEN I.TYPEINT=20        AND D.SOURCETYPE IN        ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')        THEN D.LENGTH * 2   WHEN I.TYPEINT=21        AND D.SOURCETYPE IN        ('CHARACTER','VARCHAR','LONG VARCHAR', 'BINARY', 'VARBINARY', 'BLOB','CLOB')        THEN D.LENGTH   WHEN I.TYPEINT=21        AND D.SOURCETYPE IN        ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')        THEN D.LENGTH * 2   WHEN I.TYPEINT=23 THEN C.LONGLENGTH   ELSE NULL END, C.COLNO + 1, CASE    WHEN C.NULLS='Y' THEN 'YES' ELSE 'NO' END, SMALLINT( CASE   WHEN I.TYPEINT=1 THEN 4   WHEN I.TYPEINT=2 THEN 5   WHEN I.TYPEINT=3 THEN -5   WHEN I.TYPEINT=4 THEN 7   WHEN I.TYPEINT=5 THEN 8   WHEN I.TYPEINT=6 AND C.CODEPAGE <> 0 then 1   WHEN I.TYPEINT=6 AND C.CODEPAGE = 0 then -2   WHEN I.TYPEINT=7 AND C.CODEPAGE <> 0 THEN 12   WHEN I.TYPEINT=7 AND C.CODEPAGE = 0 THEN -3   WHEN I.TYPEINT=8 AND C.CODEPAGE <> 0 THEN -1  WHEN I.TYPEINT=8 AND C.CODEPAGE = 0 THEN -4   WHEN I.TYPEINT=9 THEN 3   WHEN I.TYPEINT=10 THEN 1   WHEN I.TYPEINT=11 THEN 12   WHEN I.TYPEINT=12 THEN -1   WHEN I.TYPEINT=13 THEN 2004   WHEN I.TYPEINT=14 THEN 2005   WHEN I.TYPEINT=15 THEN 2005   WHEN I.TYPEINT=16 THEN 91   WHEN I.TYPEINT=17 THEN 92   WHEN I.TYPEINT=18 THEN 93   WHEN I.TYPEINT=19 THEN 70   WHEN I.TYPEINT=20 THEN 2002   WHEN I.TYPEINT=21 THEN 2001   WHEN I.TYPEINT=23 THEN 1111   WHEN I.TYPEINT=25 THEN -2   WHEN I.TYPEINT=26 THEN -3   ELSE 0  END), CAST( NULL AS VARCHAR(128) ), CAST( NULL AS VARCHAR(128) ), CAST( NULL AS VARCHAR(128) ), SMALLINT( CASE   WHEN D.SOURCETYPE IS NULL THEN NULL   WHEN D.SOURCETYPE='INTEGER' THEN 4   WHEN D.SOURCETYPE='SMALLINT' THEN 5   WHEN D.SOURCETYPE='BIGINT' THEN -5   WHEN D.SOURCETYPE='FLOAT' AND C.LENGTH=4 THEN 7   WHEN D.SOURCETYPE='FLOAT' AND C.LENGTH=8 THEN 8   WHEN D.SOURCETYPE='REAL' THEN 7   WHEN D.SOURCETYPE='DOUBLE' THEN 8   WHEN D.SOURCETYPE='CHARACTER' AND C.CODEPAGE <> 0 then 1   WHEN D.SOURCETYPE='CHARACTER' AND C.CODEPAGE = 0 then -2   WHEN D.SOURCETYPE='VARCHAR' AND C.CODEPAGE <> 0 THEN 12   WHEN D.SOURCETYPE='VARCHAR' AND C.CODEPAGE = 0 THEN -3   WHEN D.SOURCETYPE='LONG VARCHAR' AND C.CODEPAGE <> 0 THEN -1   WHEN D.SOURCETYPE='LONG VARCHAR' AND C.CODEPAGE = 0 THEN -4   WHEN D.SOURCETYPE='DECIMAL' THEN 3   WHEN D.SOURCETYPE='GRAPHIC' THEN -95   WHEN D.SOURCETYPE='VARGRAPHIC' THEN -96   WHEN D.SOURCETYPE='LONG VARGRAPHIC' THEN -97   WHEN D.SOURCETYPE='BLOB' THEN -98   WHEN D.SOURCETYPE='CLOB' THEN -99   WHEN D.SOURCETYPE='DBCLOB' THEN -350   WHEN D.SOURCETYPE='DATE' THEN 91   WHEN D.SOURCETYPE='TIME' THEN 92   WHEN D.SOURCETYPE='TIMESTAMP' THEN 93   WHEN D.SOURCETYPE='DATALINK' THEN -400   WHEN D.SOURCETYPE='XML' THEN -370   WHEN D.SOURCETYPE='BINARY' THEN -2   WHEN D.SOURCETYPE='VARBINARY' THEN -3   ELSE 0 END ), CAST( NULL AS VARCHAR(8) ), SMALLINT(CASE   WHEN C.IDENTITY = 'Y' THEN 2   ELSE 1 END )  FROM   SYSCAT.SYSCOLUMNS_UNION C,   SYSCAT.SYSDATATYPES_UNION D,   SYSCAT.SYSTABLES_UNION T,   TYPEINTS I,   TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B WHERE   C.COLTYPE <> 'REF'   AND I.TYPEINT <> 22    AND C.TYPENAME = D.NAME   AND C.TYPESCHEMA = D.SCHEMA   AND T.TYPE = 'A'   AND B.BASESCHEMA = C.TBCREATOR   AND B.BASENAME = C.TBNAME   AND C.COLTYPE = I.COLTYPE UNION ALL  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    C.NAME,    SMALLINT(20),    CAST( '"' || RTRIM(D.SCHEMA) || '"."' || D.NAME || '"'          AS VARCHAR(261) ),    CASE      WHEN D.SOURCETYPE = 'REAL' THEN 24      WHEN D.SOURCETYPE = 'DOUBLE' THEN 53      ELSE D.LENGTH    END,    CASE      WHEN D.SOURCETYPE             NOT IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')           THEN D.LENGTH      WHEN D.SOURCETYPE             IN ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')           THEN D.LENGTH * 2      ELSE NULL    END,    SMALLINT( CASE      WHEN D.SOURCETYPE='DECIMAL'           THEN D.SCALE      WHEN D.SOURCETYPE IN ('INTEGER','SMALLINT','BIGINT','TIME')           THEN 0      WHEN D.SOURCETYPE='TIMESTAMP'           THEN 6      ELSE NULL    END ),     SMALLINT( CASE      WHEN D.SOURCETYPE IN ('DECIMAL','INTEGER','SMALLINT','BIGINT')           THEN 10      WHEN D.SOURCETYPE IN ('REAL','FLOAT','DOUBLE')           THEN 2      ELSE NULL    END),   SMALLINT(CASE       WHEN C.NULLS='Y' THEN 1 ELSE 0     END),    C.REMARKS,    C.DEFAULT,    SMALLINT( 20 ),   SMALLINT( CASE      WHEN D.SOURCETYPE='DATE' THEN 1      WHEN D.SOURCETYPE='TIME' THEN 2      WHEN D.SOURCETYPE='TIMESTAMP' THEN 3      ELSE NULL    END),    CASE      WHEN D.SOURCETYPE IN           ('CHARACTER','VARCHAR','LONG VARCHAR','BINARY','VARBINARY','BLOB','CLOB','XML')           THEN D.LENGTH      WHEN D.SOURCETYPE IN           ('GRAPHIC','VARGRAPHIC','LONG VARGRAPHIC','DBCLOB')           THEN D.LENGTH * 2      ELSE NULL    END,    C.COLNO + 1,  CASE      WHEN C.NULLS='Y' THEN 'YES' ELSE 'NO'    END,    SMALLINT( 2006 ),    CAST( NULL AS VARCHAR(128) ),    CAST( NULL AS VARCHAR(128) ),    CAST( NULL AS VARCHAR(128) ),    SMALLINT( CASE      WHEN D.SOURCETYPE IS NULL THEN NULL      WHEN D.SOURCETYPE='INTEGER' THEN 4      WHEN D.SOURCETYPE='SMALLINT' THEN 5      WHEN D.SOURCETYPE='BIGINT' THEN -5      WHEN D.SOURCETYPE='FLOAT' AND C.LENGTH=4 THEN 7      WHEN D.SOURCETYPE='FLOAT' AND C.LENGTH=8 THEN 8      WHEN D.SOURCETYPE='REAL' THEN 7      WHEN D.SOURCETYPE='DOUBLE' THEN 8      WHEN D.SOURCETYPE='CHARACTER' AND C.CODEPAGE <> 0 then 1      WHEN D.SOURCETYPE='CHARACTER' AND C.CODEPAGE = 0 then -2      WHEN D.SOURCETYPE='VARCHAR' AND C.CODEPAGE <> 0 THEN 12      WHEN D.SOURCETYPE='VARCHAR' AND C.CODEPAGE = 0 THEN -3      WHEN D.SOURCETYPE='LONG VARCHAR' AND C.CODEPAGE <> 0 THEN -1      WHEN D.SOURCETYPE='LONG VARCHAR' AND C.CODEPAGE = 0 THEN -4      WHEN D.SOURCETYPE='DECIMAL' THEN 3      WHEN D.SOURCETYPE='GRAPHIC' THEN -95      WHEN D.SOURCETYPE='VARGRAPHIC' THEN -96      WHEN D.SOURCETYPE='LONG VARGRAPHIC' THEN -97      WHEN D.SOURCETYPE='BLOB' THEN -98      WHEN D.SOURCETYPE='CLOB' THEN -99      WHEN D.SOURCETYPE='DBCLOB' THEN -350      WHEN D.SOURCETYPE='DATE' THEN 91      WHEN D.SOURCETYPE='TIME' THEN 92      WHEN D.SOURCETYPE='TIMESTAMP' THEN 93      WHEN D.SOURCETYPE='DATALINK' THEN -400      WHEN D.SOURCETYPE='XML' THEN -370      WHEN D.SOURCETYPE='BINARY' THEN -2      WHEN D.SOURCETYPE='VARBINARY' THEN -3      ELSE 0    END ),    CAST( NULL AS VARCHAR(8) ),    SMALLINT( 1 )  FROM      SYSCAT.SYSCOLUMNS_UNION C,      SYSCAT.SYSDATATYPES_UNION D,      SYSCAT.SYSCOLPROPERTIES_UNION P,      SYSCAT.SYSTABLES_UNION T,      TYPEINTS I,      TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B    WHERE      C.COLTYPE = 'REF'      AND I.TYPEINT = 22      AND P.COLNAME = C.NAME      AND P.TABSCHEMA = C.TBCREATOR      AND P.TABNAME = C.TBNAME      AND P.TARGET_TYPENAME = D.NAME      AND P.TARGET_TYPESCHEMA = D.SCHEMA      AND T.TYPE = 'A'      AND B.BASESCHEMA = C.TBCREATOR      AND B.BASENAME = C.TBNAME      AND C.COLTYPE = I.COLTYPE;

-- View: SYSIBM.SQLFOREIGNKEYS
CREATE VIEW SYSIBM.SQLFOREIGNKEYS AS CREATE OR REPLACE VIEW SYSIBM.SQLFOREIGNKEYS(   PKTABLE_CAT,   PKTABLE_SCHEM,   PKTABLE_NAME,   PKCOLUMN_NAME,   FKTABLE_CAT,   FKTABLE_SCHEM,   FKTABLE_NAME,   FKCOLUMN_NAME,   KEY_SEQ,   UPDATE_RULE,   DELETE_RULE,   FK_NAME,   PK_NAME,   DEFERRABILITY,   UNIQUE_OR_PRIMARY ) AS  SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(T1.CREATOR),     T1.NAME,     PK.COLNAME,     CAST( NULL AS VARCHAR(128) ),     RTRIM(T2.CREATOR),     T2.NAME,     FK.COLNAME,     PK.COLSEQ,     SMALLINT(       CASE R.UPDATERULE         WHEN 'C' THEN 0         WHEN 'R' THEN 1         WHEN 'N' THEN 2         WHEN 'A' THEN 3       END), SMALLINT(       CASE R.DELETERULE         WHEN 'C' THEN 0         WHEN 'R' THEN 1         WHEN 'N' THEN 2         WHEN 'A' THEN 3       END),     FK.CONSTNAME,     PK.CONSTNAME,     SMALLINT(7),     CAST(CASE TC.CONSTRAINTYP         WHEN 'P' THEN 'PRIMARY'         WHEN 'U' THEN 'UNIQUE'     END AS CHAR(7))   FROM     SYSIBM.SYSTABLES T1,     SYSIBM.SYSTABLES T2,     SYSIBM.SYSRELS R,     SYSIBM.SYSKEYCOLUSE PK,     SYSIBM.SYSKEYCOLUSE FK,     SYSIBM.SYSTABCONST TC,     TABLE(SYSPROC.BASE_TABLE(T1.CREATOR, T1.NAME)) AS B1,     TABLE(SYSPROC.BASE_TABLE(T2.CREATOR, T2.NAME)) AS B2   WHERE     PK.COLSEQ        = FK.COLSEQ     AND PK.TBNAME    = R.REFTBNAME     AND PK.TBCREATOR = R.REFTBCREATOR     AND FK.TBNAME    = R.TBNAME      AND FK.TBCREATOR = R.CREATOR     AND PK.CONSTNAME = R.REFKEYNAME     AND FK.CONSTNAME = R.RELNAME     AND TC.NAME = R.REFKEYNAME     AND TC.TBNAME    = PK.TBNAME     AND TC.TBCREATOR = PK.TBCREATOR     AND B1.BASESCHEMA = R.REFTBCREATOR     AND B1.BASENAME   = R.REFTBNAME     AND B2.BASESCHEMA = R.CREATOR     AND B2.BASENAME   = R.TBNAME     AND T1.TYPE IN ('A', 'T')     AND T2.TYPE IN ('A', 'T');

-- View: SYSIBM.SQLPRIMARYKEYS
CREATE VIEW SYSIBM.SQLPRIMARYKEYS AS CREATE OR REPLACE VIEW SYSIBM.SQLPRIMARYKEYS (   TABLE_CAT,   TABLE_SCHEM,   TABLE_NAME,   COLUMN_NAME,   KEY_SEQ,   PK_NAME ) AS    SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(C.TBCREATOR),     C.TBNAME,     C.NAME,     C.KEYSEQ,     T.NAME   FROM     SYSIBM.SYSCOLUMNS C,     SYSIBM.SYSTABCONST T   WHERE     C.KEYSEQ > 0     AND T.CONSTRAINTYP = 'P'     AND T.TBCREATOR = C.TBCREATOR     AND T.TBNAME = C.TBNAME UNION   SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(C.TBCREATOR),     T.NAME,     C.NAME,     C.KEYSEQ,     TC.NAME   FROM     SYSIBM.SYSCOLUMNS C,     SYSIBM.SYSTABLES  T,     SYSIBM.SYSTABCONST TC,     TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B   WHERE     C.KEYSEQ > 0     AND T.TYPE = 'A'     AND B.BASESCHEMA = C.TBCREATOR     AND B.BASENAME = C.TBNAME     AND TC.CONSTRAINTYP = 'P'     AND TC.TBCREATOR = C.TBCREATOR     AND TC.TBNAME = C.TBNAME;

-- View: SYSIBM.SQLPROCEDURECOLS
CREATE VIEW SYSIBM.SQLPROCEDURECOLS AS CREATE OR REPLACE VIEW SYSIBM.SQLPROCEDURECOLS(     PROCEDURE_CAT,     PROCEDURE_SCHEM,     PROCEDURE_NAME,     COLUMN_NAME,     COLUMN_TYPE,     DATA_TYPE,     TYPE_NAME,     COLUMN_SIZE,     BUFFER_LENGTH,     DECIMAL_DIGITS,     NUM_PREC_RADIX,     NULLABLE,     REMARKS,     COLUMN_DEF,     SQL_DATA_TYPE,     SQL_DATETIME_SUB,     CHAR_OCTET_LENGTH,     ORDINAL_POSITION,     IS_NULLABLE,     JDBC_DATA_TYPE ) AS  SELECT CAST( NULL AS VARCHAR(128) ),  RTRIM(PARM.ROUTINESCHEMA),  PARM.ROUTINENAME,  PARM.PARMNAME,  SMALLINT( CASE      WHEN ROWTYPE = 'P' THEN 1      WHEN ROWTYPE = 'O' THEN 4      WHEN ROWTYPE = 'B' THEN 2      ELSE 0  END), SMALLINT( CASE     WHEN TYPENAME='INTEGER' THEN 4     WHEN TYPENAME='SMALLINT' THEN 5     WHEN TYPENAME='BIGINT' THEN -5     WHEN TYPENAME='FLOAT' AND LENGTH=4 THEN 7     WHEN TYPENAME='FLOAT' AND LENGTH=8 THEN 8     WHEN TYPENAME='REAL' THEN 7     WHEN TYPENAME='DOUBLE' THEN 8     WHEN TYPENAME='CHARACTER' AND PARM.CODEPAGE <> 0 then 1     WHEN TYPENAME='CHARACTER' AND PARM.CODEPAGE = 0 then -2     WHEN TYPENAME='VARCHAR' AND PARM.CODEPAGE <> 0 THEN 12     WHEN TYPENAME='VARCHAR' AND PARM.CODEPAGE = 0 THEN -3     WHEN TYPENAME='LONGVAR' AND PARM.CODEPAGE <> 0 THEN -1     WHEN TYPENAME='LONGVAR' AND PARM.CODEPAGE = 0 THEN -4     WHEN TYPENAME='DECIMAL' THEN 3     WHEN TYPENAME='GRAPHIC' THEN -95     WHEN TYPENAME='VARG' THEN -96     WHEN TYPENAME='LONGVARG' THEN -97     WHEN TYPENAME='BLOB' THEN -98     WHEN TYPENAME='CLOB' THEN -99     WHEN TYPENAME='DBCLOB' THEN -350     WHEN TYPENAME='DATE' THEN 91     WHEN TYPENAME='TIME' THEN 92     WHEN TYPENAME='TIMESTAMP' THEN 93     WHEN TYPENAME='DATALINK' THEN -400     WHEN TYPENAME='XML' THEN -370     WHEN TYPENAME='BINARY' THEN -2     WHEN TYPENAME='VARBINARY' THEN -3     WHEN TYPENAME='BOOLEAN' THEN 16    ELSE 0 END),  CAST( CASE     WHEN TYPENAME='INTEGER' THEN 'INTEGER'     WHEN TYPENAME='SMALLINT' THEN 'SMALLINT'     WHEN TYPENAME='BIGINT' THEN 'BIGINT'     WHEN TYPENAME='FLOAT' AND LENGTH=4 THEN 'REAL'     WHEN TYPENAME='FLOAT' AND LENGTH=8 THEN 'DOUBLE'     WHEN TYPENAME='REAL' THEN 'REAL'     WHEN TYPENAME='DOUBLE' THEN 'DOUBLE'     WHEN TYPENAME='CHARACTER' AND PARM.CODEPAGE <> 0 THEN 'CHAR'     WHEN TYPENAME='CHARACTER' AND PARM.CODEPAGE = 0 THEN 'CHAR () FOR BIT DATA'     WHEN TYPENAME='VARCHAR' AND PARM.CODEPAGE <> 0 THEN 'VARCHAR'     WHEN TYPENAME='VARCHAR' AND PARM.CODEPAGE = 0 THEN 'VARCHAR () FOR BIT DATA'     WHEN TYPENAME='LONGVAR' AND PARM.CODEPAGE <> 0 THEN 'LONG VARCHAR'     WHEN TYPENAME='LONGVAR' AND PARM.CODEPAGE = 0 THEN 'LONG VARCHAR FOR BIT DATA'     WHEN TYPENAME='DECIMAL' THEN 'DECIMAL'     WHEN TYPENAME='GRAPHIC' THEN 'GRAPHIC'     WHEN TYPENAME='VARG' THEN 'VARGRAPHIC'     WHEN TYPENAME='LONGVARG' THEN 'LONG VARGRAPHIC'     WHEN TYPENAME='BLOB' THEN 'BLOB'     WHEN TYPENAME='CLOB' THEN 'CLOB'     WHEN TYPENAME='DBCLOB' THEN 'DBCLOB'     WHEN TYPENAME='DATE' THEN 'DATE'     WHEN TYPENAME='TIME' THEN 'TIME'     WHEN TYPENAME='TIMESTAMP' THEN 'TIMESTAMP'     WHEN TYPENAME='DATALINK' THEN 'DATALINK'     WHEN TYPENAME='XML' THEN 'XML'     WHEN TYPENAME='BINARY' THEN 'BINARY'     WHEN TYPENAME='VARBINARY' THEN 'VARBINARY'     WHEN TYPENAME='BOOLEAN' THEN 'BOOLEAN'     ELSE TYPENAME END AS VARCHAR(261) ),  CASE     WHEN TYPENAME='INTEGER' THEN 10     WHEN TYPENAME='SMALLINT' THEN 5     WHEN TYPENAME='BIGINT' THEN 19     WHEN TYPENAME='FLOAT' AND LENGTH=4 THEN 7     WHEN TYPENAME='FLOAT' AND LENGTH=8 THEN 15     WHEN TYPENAME='REAL' THEN 7     WHEN TYPENAME='DOUBLE' THEN 15     WHEN TYPENAME='CHARACTER' THEN LENGTH     WHEN TYPENAME='VARCHAR' THEN LENGTH     WHEN TYPENAME='LONGVAR' THEN LENGTH     WHEN TYPENAME='BINARY' THEN LENGTH     WHEN TYPENAME='VARBINARY' THEN LENGTH     WHEN TYPENAME='DECIMAL' THEN LENGTH     WHEN TYPENAME='GRAPHIC' THEN LENGTH     WHEN TYPENAME='VARG' THEN LENGTH     WHEN TYPENAME='LONGVARG' THEN LENGTH     WHEN TYPENAME='BLOB' THEN LENGTH     WHEN TYPENAME='CLOB' THEN LENGTH     WHEN TYPENAME='DBCLOB' THEN LENGTH     WHEN TYPENAME='DATE' THEN 10     WHEN TYPENAME='TIME' THEN 8     WHEN TYPENAME='TIMESTAMP' THEN       CASE WHEN SCALE=0 THEN 19            ELSE 20+SCALE       END     WHEN TYPENAME='XML' THEN LENGTH     WHEN TYPENAME='BOOLEAN' THEN 1     ELSE LENGTH END, CASE     WHEN TYPENAME='INTEGER' THEN 4     WHEN TYPENAME='SMALLINT' THEN 2     WHEN TYPENAME='BIGINT' THEN 8     WHEN TYPENAME='FLOAT' AND LENGTH=4 THEN 4     WHEN TYPENAME='FLOAT' AND LENGTH=8 THEN 8     WHEN TYPENAME='REAL' THEN 4     WHEN TYPENAME='DOUBLE' THEN 8     WHEN TYPENAME='CHARACTER' THEN LENGTH     WHEN TYPENAME='VARCHAR' THEN LENGTH     WHEN TYPENAME='LONGVAR' THEN LENGTH     WHEN TYPENAME='BINARY' THEN LENGTH     WHEN TYPENAME='VARBINARY' THEN LENGTH     WHEN TYPENAME='DECIMAL' THEN LENGTH + 2     WHEN TYPENAME='GRAPHIC' THEN LENGTH * 2     WHEN TYPENAME='VARG' THEN LENGTH * 2     WHEN TYPENAME='LONGVARG' THEN LENGTH * 2     WHEN TYPENAME='BLOB' THEN LENGTH     WHEN TYPENAME='CLOB' THEN LENGTH     WHEN TYPENAME='DBCLOB' THEN LENGTH * 2     WHEN TYPENAME='DATE' THEN 6     WHEN TYPENAME='TIME' THEN 6     WHEN TYPENAME='TIMESTAMP' THEN 16     WHEN TYPENAME='XML' THEN LENGTH     WHEN TYPENAME='BOOLEAN' THEN 1     ELSE LENGTH END, CAST( CASE     WHEN TYPENAME='DECIMAL' THEN SCALE     WHEN TYPENAME='INTEGER' THEN 0     WHEN TYPENAME='SMALLINT' THEN 0     WHEN TYPENAME='BIGINT' THEN 0     WHEN TYPENAME='TIMESTAMP' THEN SCALE     WHEN TYPENAME='BOOLEAN' THEN 0     ELSE NULL END AS SMALLINT ),    CAST( CASE     WHEN TYPENAME='DECIMAL' THEN 10     WHEN TYPENAME='INTEGER' THEN 10     WHEN TYPENAME='SMALLINT' THEN 10     WHEN TYPENAME='BIGINT' THEN 10     WHEN TYPENAME='REAL' THEN 10     WHEN TYPENAME='FLOAT' THEN 10     WHEN TYPENAME='DOUBLE' THEN 10     WHEN TYPENAME='BOOLEAN' THEN 1     ELSE NULL END AS SMALLINT ), 1, PROC.REMARKS, CAST( NULL AS VARCHAR(254) ), SMALLINT(CASE     WHEN TYPENAME='INTEGER' THEN 4     WHEN TYPENAME='SMALLINT' THEN 5     WHEN TYPENAME='BIGINT' THEN -5     WHEN TYPENAME='FLOAT' AND LENGTH=4 THEN 7     WHEN TYPENAME='FLOAT' AND LENGTH=8 THEN 8     WHEN TYPENAME='REAL' THEN 7     WHEN TYPENAME='DOUBLE' THEN 8     WHEN TYPENAME='CHARACTER' THEN 1     WHEN TYPENAME='VARCHAR' THEN 12     WHEN TYPENAME='LONGVAR' THEN -1     WHEN TYPENAME='DECIMAL' THEN 3     WHEN TYPENAME='GRAPHIC' THEN -95     WHEN TYPENAME='VARG' THEN -96     WHEN TYPENAME='LONGVARG' THEN -97     WHEN TYPENAME='BLOB' THEN -98     WHEN TYPENAME='CLOB' THEN -99     WHEN TYPENAME='DBCLOB' THEN -350     WHEN TYPENAME='DATE' THEN 9     WHEN TYPENAME='TIME' THEN 9     WHEN TYPENAME='TIMESTAMP' THEN 9     WHEN TYPENAME='XML' THEN -370     WHEN TYPENAME='BINARY' THEN -2     WHEN TYPENAME='VARBINARY' THEN -3     WHEN TYPENAME='BOOLEAN' THEN 16     ELSE 0 END),  SMALLINT( CASE     WHEN TYPENAME='DATE' THEN 1     WHEN TYPENAME='TIME' THEN 2     WHEN TYPENAME='TIMESTAMP' THEN 3     ELSE NULL END), CASE     WHEN TYPENAME='CHARACTER' THEN LENGTH     WHEN TYPENAME='VARCHAR' THEN LENGTH     WHEN TYPENAME='LONGVAR' THEN LENGTH     WHEN TYPENAME='GRAPHIC' THEN LENGTH * 2     WHEN TYPENAME='VARG' THEN LENGTH * 2     WHEN TYPENAME='LONGVARG' THEN LENGTH * 2     WHEN TYPENAME='BLOB' THEN LENGTH     WHEN TYPENAME='CLOB' THEN LENGTH     WHEN TYPENAME='DBCLOB' THEN LENGTH * 2     WHEN TYPENAME='XML' THEN LENGTH     WHEN TYPENAME='BINARY' THEN LENGTH     WHEN TYPENAME='VARBINARY' THEN LENGTH     ELSE NULL END, CAST( ORDINAL AS INTEGER ), CAST('YES' AS VARCHAR(3)),  SMALLINT( CASE   WHEN TYPENAME='INTEGER' THEN 4   WHEN TYPENAME='SMALLINT' THEN 5   WHEN TYPENAME='BIGINT' THEN -5   WHEN TYPENAME='FLOAT' AND LENGTH=4 THEN 7    WHEN TYPENAME='FLOAT' AND LENGTH=8 THEN 8   WHEN TYPENAME='REAL' THEN 7   WHEN TYPENAME='DOUBLE' THEN 8   WHEN TYPENAME='CHAR' AND PARM.CODEPAGE <> 0 then 1   WHEN TYPENAME='CHAR' AND PARM.CODEPAGE = 0 then -2   WHEN TYPENAME='VARCHAR' AND PARM.CODEPAGE <> 0 THEN 12   WHEN TYPENAME='VARCHAR' AND PARM.CODEPAGE = 0 THEN -3   WHEN TYPENAME='LONGVAR' AND PARM.CODEPAGE <> 0 THEN -1   WHEN TYPENAME='LONGVAR' AND PARM.CODEPAGE = 0 THEN -4   WHEN TYPENAME='DECIMAL' THEN 3   WHEN TYPENAME='GRAPHIC' THEN 1   WHEN TYPENAME='VARG' THEN 12   WHEN TYPENAME='LONGVARG' THEN -1   WHEN TYPENAME='BLOB' THEN 2004   WHEN TYPENAME='CLOB' THEN 2005   WHEN TYPENAME='DBCLOB' THEN 2005   WHEN TYPENAME='DATE' THEN 91   WHEN TYPENAME='TIME' THEN 92   WHEN TYPENAME='TIMESTAMP' THEN 93   WHEN TYPENAME='XML' THEN 1111   WHEN TYPENAME='BINARY' THEN -2   WHEN TYPENAME='VARBINARY' THEN -3   WHEN TYPENAME='BOOLEAN' THEN 16   ELSE 0 END) FROM     SYSIBM.SYSROUTINEPARMS PARM, SYSCAT.ROUTINES PROC WHERE     PROC.ROUTINETYPE = 'P'     AND PARM.ROUTINETYPE = 'P'     AND PARM.ROUTINESCHEMA = PROC.ROUTINESCHEMA     AND PARM.ROUTINENAME = PROC.ROUTINENAME;

-- View: SYSIBM.SQLPROCEDURES
CREATE VIEW SYSIBM.SQLPROCEDURES AS CREATE OR REPLACE VIEW SYSIBM.SQLPROCEDURES (   PROCEDURE_CAT,   PROCEDURE_SCHEM,   PROCEDURE_NAME,   NUM_INPUT_PARAMS,   NUM_OUTPUT_PARAMS,   NUM_RESULT_SETS,   REMARKS,   PROCEDURE_TYPE,   NUM_INOUT_PARAMS ) AS  WITH  IN ( ROUTINESCHEMA, ROUTINENAME, INCOUNT )   AS ( SELECT ROUTINESCHEMA, ROUTINENAME, COUNT(*)          FROM SYSIBM.SYSROUTINEPARMS          WHERE ROUTINETYPE = 'P'            AND ROWTYPE = 'P'          GROUP BY ROUTINESCHEMA, ROUTINENAME        UNION ALL        SELECT ROUTINESCHEMA, ROUTINENAME, 0          FROM SYSIBM.SYSROUTINES          WHERE ROUTINETYPE = 'P'            AND (ROUTINESCHEMA, ROUTINENAME)            NOT IN ( SELECT ROUTINESCHEMA, ROUTINENAME                     FROM SYSIBM.SYSROUTINEPARMS                     WHERE ROUTINETYPE = 'P'                       AND ROWTYPE = 'P' ) ),  OUT ( ROUTINESCHEMA, ROUTINENAME, OUTCOUNT )   AS ( SELECT ROUTINESCHEMA, ROUTINENAME, COUNT(*)          FROM SYSIBM.SYSROUTINEPARMS          WHERE ROUTINETYPE = 'P'            AND ROWTYPE = 'O'          GROUP BY ROUTINESCHEMA, ROUTINENAME        UNION ALL        SELECT ROUTINESCHEMA, ROUTINENAME, 0          FROM SYSIBM.SYSROUTINES          WHERE ROUTINETYPE = 'P'            AND (ROUTINESCHEMA, ROUTINENAME)            NOT IN ( SELECT ROUTINESCHEMA, ROUTINENAME                     FROM SYSIBM.SYSROUTINEPARMS                     WHERE ROUTINETYPE = 'P'                       AND ROWTYPE = 'O' ) ),  INOUT ( ROUTINESCHEMA, ROUTINENAME, INOUTCOUNT )   AS ( SELECT ROUTINESCHEMA, ROUTINENAME, COUNT(*)          FROM SYSIBM.SYSROUTINEPARMS          WHERE ROUTINETYPE = 'P'            AND ROWTYPE = 'B'          GROUP BY ROUTINESCHEMA, ROUTINENAME        UNION ALL        SELECT ROUTINESCHEMA, ROUTINENAME, 0          FROM SYSIBM.SYSROUTINES          WHERE ROUTINETYPE = 'P'            AND (ROUTINESCHEMA, ROUTINENAME)            NOT IN ( SELECT ROUTINESCHEMA, ROUTINENAME                     FROM SYSIBM.SYSROUTINEPARMS                     WHERE ROUTINETYPE = 'P'                       AND ROWTYPE = 'B' ) )   SELECT DISTINCT    CAST( NULL AS VARCHAR(128) ),     RTRIM(P.ROUTINESCHEMA),     P.ROUTINENAME,     I.INCOUNT,     O.OUTCOUNT,     P.RESULT_SETS,     P.REMARKS,     SMALLINT(1),     IO.INOUTCOUNT   FROM     SYSIBM.SYSROUTINES P,     IN I,     OUT O,     INOUT IO   WHERE P.ROUTINETYPE = 'P'     AND P.ROUTINESCHEMA = I.ROUTINESCHEMA     AND P.ROUTINENAME   = I.ROUTINENAME     AND P.ROUTINESCHEMA = O.ROUTINESCHEMA     AND P.ROUTINENAME   = O.ROUTINENAME     AND P.ROUTINESCHEMA = IO.ROUTINESCHEMA     AND P.ROUTINENAME   = IO.ROUTINENAME;

-- View: SYSIBM.SQLSCHEMAS
CREATE VIEW SYSIBM.SQLSCHEMAS AS CREATE OR REPLACE VIEW SYSIBM.SQLSCHEMAS (     TABLE_CAT,     TABLE_SCHEM,     TABLE_NAME,     TABLE_TYPE,     REMARKS,     TYPE_CAT,     TYPE_SCHEM,     TYPE_NAME,     SELF_REF_COL_NAME,     REF_GENERATION,     DBNAME ) AS   SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(NAME),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(254) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(8) )   FROM     SYSIBM.SYSSCHEMATA;

-- View: SYSIBM.SQLSPECIALCOLUMNS
CREATE VIEW SYSIBM.SQLSPECIALCOLUMNS AS CREATE OR REPLACE VIEW SYSIBM.SQLSPECIALCOLUMNS(  SCOPE,  COLUMN_NAME,  DATA_TYPE,  TYPE_NAME,  COLUMN_SIZE,  BUFFER_LENGTH,  DECIMAL_DIGITS,  PSEUDO_COLUMN,  TABLE_CAT,  TABLE_SCHEM,  TABLE_NAME,  NULLABLE,  JDBC_DATA_TYPE ) AS  WITH IDTABLES ( A, B )  AS ( SELECT TBCREATOR AS A, TBNAME AS B   FROM SYSIBM.SYSCOLUMNS   WHERE IDENTITY = 'Y' ), SUBINDEXES ( NAME, CREATOR, TBNAME, TBCREATOR, UNIQUERULE, COLCOUNT, IID )  AS (   SELECT I.NAME, I.CREATOR, I.TBNAME, I.TBCREATOR,    I.UNIQUERULE, I.COLCOUNT, I.IID    FROM SYSIBM.SYSINDEXES I    WHERE I.UNIQUERULE IN ( 'P', 'U' )     AND (I.TBCREATOR, I.TBNAME)      NOT IN (SELECT A, B FROM IDTABLES) ), OPTIMALINDEXES ( NAME, CREATOR ) AS (   SELECT NAME AS A, CREATOR AS B     FROM SUBINDEXES I     WHERE I.UNIQUERULE = 'P'   UNION ALL   SELECT NAME AS A, CREATOR AS B    FROM SUBINDEXES    WHERE UNIQUERULE = 'U'    AND (TBCREATOR, TBNAME) NOT IN (     SELECT TBCREATOR, TBNAME     FROM SUBINDEXES WHERE UNIQUERULE = 'P' )    AND ( TBNAME, TBCREATOR, IID)     IN ( SELECT TBNAME, TBCREATOR, MIN(IID)      FROM SUBINDEXES      WHERE (TBNAME, TBCREATOR, COLCOUNT)      IN ( SELECT TBNAME, TBCREATOR, MIN(COLCOUNT)       FROM SUBINDEXES       GROUP BY TBNAME, TBCREATOR )      GROUP BY TBNAME, TBCREATOR ) )   SELECT    SMALLINT(0),    Q.COLUMN_NAME,    Q.DATA_TYPE,    Q.TYPE_NAME,    Q.COLUMN_SIZE,    Q.BUFFER_LENGTH,    Q.DECIMAL_DIGITS,    Q.PSEUDO_COLUMN,    CAST( NULL AS VARCHAR(128) ),    RTRIM(Q.TABLE_SCHEM),    Q.TABLE_NAME,    Q.NULLABLE,    Q.JDBC_DATA_TYPE  FROM    OPTIMALINDEXES O,    SYSIBM.SYSINDEXES I,    SYSIBM.SYSINDEXCOLUSE U,    SYSIBM.SQLCOLUMNS Q  WHERE    I.NAME = O.NAME    AND I.CREATOR = O.CREATOR    AND Q.DATA_TYPE <> 20    AND Q.TABLE_SCHEM = I.TBCREATOR    AND Q.TABLE_NAME = I.TBNAME    AND I.CREATOR = U.INDSCHEMA    AND I.NAME = U.INDNAME    AND Q.COLUMN_NAME = U.COLNAME UNION ALL SELECT    SMALLINT(0),    Q.COLUMN_NAME,    20,    Q.TYPE_NAME,    Q.COLUMN_SIZE,    Q.BUFFER_LENGTH,    Q.DECIMAL_DIGITS,    Q.PSEUDO_COLUMN,    CAST( NULL AS VARCHAR(128) ),    RTRIM(Q.TABLE_SCHEM),    Q.TABLE_NAME,    Q.NULLABLE,    Q.JDBC_DATA_TYPE   FROM    OPTIMALINDEXES O,    SYSIBM.SYSINDEXES I,    SYSIBM.SYSINDEXCOLUSE U,    SYSIBM.SQLCOLUMNS Q   WHERE     I.NAME = O.NAME    AND I.CREATOR = O.CREATOR    AND Q.DATA_TYPE = 20    AND Q.TABLE_SCHEM = I.TBCREATOR    AND Q.TABLE_NAME = I.TBNAME    AND I.CREATOR = U.INDSCHEMA    AND I.NAME = U.INDNAME    AND Q.COLUMN_NAME = U.COLNAME UNION ALL  SELECT    SMALLINT(0),    Q.COLUMN_NAME,    Q.DATA_TYPE,    Q.TYPE_NAME,    Q.COLUMN_SIZE,    Q.BUFFER_LENGTH,    Q.DECIMAL_DIGITS,    Q.PSEUDO_COLUMN,    CAST( NULL AS VARCHAR(128) ),    RTRIM(Q.TABLE_SCHEM),    Q.TABLE_NAME,    Q.NULLABLE,    Q.JDBC_DATA_TYPE  FROM     SYSIBM.SYSCOLUMNS C,    SYSIBM.SQLCOLUMNS Q  WHERE    C.TBCREATOR = Q.TABLE_SCHEM    AND C.TBNAME = Q.TABLE_NAME    AND C.NAME = Q.COLUMN_NAME    AND C.IDENTITY = 'Y' UNION ALL SELECT    SMALLINT(0),    Q.COLUMN_NAME,    Q.DATA_TYPE,    Q.TYPE_NAME,    Q.COLUMN_SIZE,    Q.BUFFER_LENGTH,    Q.DECIMAL_DIGITS,    Q.PSEUDO_COLUMN,    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    Q.NULLABLE,    Q.JDBC_DATA_TYPE   FROM    OPTIMALINDEXES O,    SYSIBM.SYSINDEXES I,    SYSIBM.SYSINDEXCOLUSE U,    SYSIBM.SYSTABLES T,    SYSIBM.SQLCOLUMNS Q,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE    I.NAME = O.NAME    AND I.CREATOR = O.CREATOR    AND Q.DATA_TYPE <> 20    AND Q.TABLE_SCHEM = I.TBCREATOR    AND Q.TABLE_NAME = I.TBNAME    AND I.CREATOR = U.INDSCHEMA    AND I.NAME = U.INDNAME    AND Q.COLUMN_NAME = U.COLNAME    AND T.TYPE = 'A'    AND B.BASESCHEMA = Q.TABLE_SCHEM    AND B.BASENAME = Q.TABLE_NAME  UNION ALL SELECT    SMALLINT(0),    Q.COLUMN_NAME,    20,    Q.TYPE_NAME,    Q.COLUMN_SIZE,    Q.BUFFER_LENGTH,    Q.DECIMAL_DIGITS,    Q.PSEUDO_COLUMN,    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    Q.NULLABLE,    Q.JDBC_DATA_TYPE FROM    OPTIMALINDEXES O,    SYSIBM.SYSINDEXES I,    SYSIBM.SYSINDEXCOLUSE U,    SYSIBM.SYSTABLES T,    SYSIBM.SQLCOLUMNS Q,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE    I.NAME = O.NAME    AND I.CREATOR = O.CREATOR    AND Q.DATA_TYPE = 20     AND Q.TABLE_SCHEM = I.TBCREATOR    AND Q.TABLE_NAME = I.TBNAME    AND I.CREATOR = U.INDSCHEMA    AND I.NAME = U.INDNAME    AND Q.COLUMN_NAME = U.COLNAME    AND T.TYPE = 'A'    AND B.BASESCHEMA = Q.TABLE_SCHEM    AND B.BASENAME = Q.TABLE_NAME UNION ALL  SELECT    SMALLINT(0),    C.NAME,    Q.DATA_TYPE,    Q.TYPE_NAME,    Q.COLUMN_SIZE,    Q.BUFFER_LENGTH,    Q.DECIMAL_DIGITS,    Q.PSEUDO_COLUMN,    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    Q.NULLABLE,    Q.JDBC_DATA_TYPE  FROM    SYSIBM.SYSCOLUMNS C,    SYSIBM.SQLCOLUMNS Q,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE    C.TBCREATOR = Q.TABLE_SCHEM    AND C.TBNAME = Q.TABLE_NAME    AND C.NAME = Q.COLUMN_NAME    AND C.IDENTITY = 'Y'     AND T.TYPE = 'A'    AND B.BASESCHEMA = C.TBCREATOR    AND B.BASENAME = C.TBNAME;

-- View: SYSIBM.SQLSTATISTICS
CREATE VIEW SYSIBM.SQLSTATISTICS AS CREATE OR REPLACE VIEW SYSIBM.SQLSTATISTICS (     TABLE_CAT,     TABLE_SCHEM,     TABLE_NAME,     NON_UNIQUE,     INDEX_QUALIFIER,     INDEX_NAME,     TYPE,     ORDINAL_POSITION,     COLUMN_NAME,     ASC_OR_DESC,     CARDINALITY,     PAGES,     FILTER_CONDITION ) AS  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(I.TBCREATOR),    I.TBNAME,    SMALLINT( CASE     WHEN I.UNIQUERULE='D' THEN 1     WHEN I.UNIQUERULE='P' THEN 0     WHEN I.UNIQUERULE='U' THEN 0     ELSE 0    END),    RTRIM(I.CREATOR),    I.NAME,    SMALLINT(CASE     WHEN I.INDEXTYPE='CLUS' THEN 1     WHEN I.INDEXTYPE='REG'  THEN 3     ELSE 3    END),    SMALLINT(U.COLSEQ),    U.COLNAME,    CASE WHEN U.COLORDER='A' THEN CAST('A' AS CHAR(1))         WHEN U.COLORDER='D' THEN CAST('D' AS CHAR(1))         ELSE CAST(NULL AS CHAR(1))    END,    CASE WHEN I.FULLKEYCARD=-1 THEN NULL ELSE I.FULLKEYCARD END,    INTEGER(CASE WHEN I.NLEAF=-1 THEN NULL            WHEN I.NLEAF > 2147483647 THEN 2147483647            ELSE I.NLEAF END),    CAST( NULL AS VARCHAR(128) )  FROM    SYSIBM.SYSINDEXES I,    SYSIBM.SYSINDEXCOLUSE U  WHERE    U.INDSCHEMA = I.CREATOR    AND U.INDNAME = I.NAME    AND I.INDEXTYPE <> 'XRGN'     AND I.INDEXTYPE <> 'XPTH'     AND I.INDEXTYPE <> 'XVIP'   UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(CREATOR),    NAME,    CAST( NULL AS SMALLINT ),    CAST( NULL AS VARCHAR(128) ),    CAST( NULL AS VARCHAR(128) ),    CAST( 0 AS SMALLINT ),    CAST( NULL AS SMALLINT ),     CAST( NULL AS VARCHAR(128) ),    CAST( NULL AS CHAR(1) ),    CASE WHEN CARD=-1 THEN NULL ELSE CARD END,    INTEGER(CASE      WHEN NPAGES=-1 THEN NULL      WHEN NPAGES=-2 THEN NULL      WHEN NPAGES > 2147483647 THEN 2147483647      ELSE NPAGES    END),    CAST( NULL AS VARCHAR(128) )  FROM    SYSIBM.SYSTABLES UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    SMALLINT( CASE     WHEN I.UNIQUERULE='D' THEN 1     WHEN I.UNIQUERULE='P' THEN 0     WHEN I.UNIQUERULE='U' THEN 0     ELSE 0    END),    RTRIM(I.CREATOR),    I.NAME,    SMALLINT( CASE     WHEN I.INDEXTYPE='CLUS' THEN 1     WHEN I.INDEXTYPE='REG'  THEN 3     ELSE 3    END),    SMALLINT(U.COLSEQ),    U.COLNAME,    CASE WHEN U.COLORDER='A' THEN CAST('A' AS CHAR(1))         WHEN U.COLORDER='D' THEN CAST('D' AS CHAR(1))         ELSE CAST(NULL AS CHAR(1))    END,    CASE WHEN I.FULLKEYCARD=-1 THEN NULL ELSE I.FULLKEYCARD END,    INTEGER(CASE WHEN I.NLEAF=-1 THEN NULL            WHEN I.NLEAF > 2147483647 THEN 2147483647            ELSE I.NLEAF END),    CAST( NULL AS VARCHAR(128) )  FROM    SYSIBM.SYSINDEXES I,    SYSIBM.SYSINDEXCOLUSE U,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE    U.INDSCHEMA = I.CREATOR    AND U.INDNAME = I.NAME    AND T.TYPE = 'A'    AND I.INDEXTYPE <> 'XRGN'     AND I.INDEXTYPE <> 'XPTH'     AND I.INDEXTYPE <> 'XVIP'     AND B.BASESCHEMA = I.TBCREATOR    AND B.BASENAME = I.TBNAME;

-- View: SYSIBM.SQLTABLEPRIVILEGES
CREATE VIEW SYSIBM.SQLTABLEPRIVILEGES AS CREATE OR REPLACE VIEW SYSIBM.SQLTABLEPRIVILEGES (  TABLE_CAT,  TABLE_SCHEM,  TABLE_NAME,  GRANTOR,  GRANTEE,  PRIVILEGE,  IS_GRANTABLE,  DBNAME ) AS  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(TCREATOR),    TTNAME,    RTRIM(GRANTOR),    RTRIM(GRANTEE),    CAST('ALTER' AS VARCHAR(10)),                   CAST(CASE                                         WHEN ALTERAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),                          CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH  WHERE    ALTERAUTH IN ('Y', 'G')  UNION SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(TCREATOR),    TTNAME,    RTRIM(GRANTOR),    RTRIM(GRANTEE),    CAST('DELETE' AS VARCHAR(10)),                  CAST(CASE                                         WHEN DELETEAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),                           CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH  WHERE    DELETEAUTH IN ('Y', 'G')  UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(TCREATOR),    TTNAME,    RTRIM(GRANTOR),    RTRIM(GRANTEE),    CAST('CONTROL' AS VARCHAR(10)),                                      CAST('NO' AS VARCHAR(3)),                                            CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH  WHERE    CONTROLAUTH='Y'  UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(TCREATOR),    TTNAME,    RTRIM(GRANTOR),    RTRIM(GRANTEE),    CAST('INDEX' AS VARCHAR(10)),      CAST(CASE                                      WHEN INDEXAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),                          CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH  WHERE    INDEXAUTH IN ('Y', 'G') UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(TCREATOR),    TTNAME,    RTRIM(GRANTOR),    RTRIM(GRANTEE),    CAST('INSERT' AS VARCHAR(10)),     CAST(CASE                                       WHEN INSERTAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH  WHERE    INSERTAUTH IN ('Y', 'G')  UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(TCREATOR),    TTNAME,    RTRIM(GRANTOR),    RTRIM(GRANTEE),    CAST('REFERENCES' AS VARCHAR(10)),                              CAST(CASE                                                         WHEN REFAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH  WHERE    REFAUTH IN ('Y', 'G') UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(TCREATOR),    TTNAME,    RTRIM(GRANTOR),    RTRIM(GRANTEE),    CAST('SELECT' AS VARCHAR(10)),     CAST(CASE                                       WHEN SELECTAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH  WHERE    SELECTAUTH IN ('Y', 'G')  UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(TCREATOR),    TTNAME,    RTRIM(GRANTOR),    RTRIM(GRANTEE),    CAST('UPDATE' AS VARCHAR(10)),     CAST(CASE                                       WHEN UPDATEAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH  WHERE      UPDATEAUTH IN ('Y', 'G') UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('ALTER' AS VARCHAR(10)),        CAST(CASE                                        WHEN A.ALTERAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH A,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE      A.ALTERAUTH IN ('Y', 'G')      AND T.TYPE = 'A'      AND B.BASESCHEMA = A.TCREATOR      AND B.BASENAME = A.TTNAME UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('CONTROL'  AS VARCHAR(10)),      CAST('NO' AS VARCHAR(3)),                            CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH A,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE      A.CONTROLAUTH='Y'      AND T.TYPE = 'A'      AND B.BASESCHEMA = A.TCREATOR      AND B.BASENAME = A.TTNAME UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('DELETE'  AS VARCHAR(10)),       CAST(CASE                                         WHEN A.DELETEAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH A,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE      A.DELETEAUTH IN ('Y','G')      AND T.TYPE = 'A'      AND B.BASESCHEMA = A.TCREATOR      AND B.BASENAME = A.TTNAME UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('INDEX' AS VARCHAR(10)),        CAST(CASE                                        WHEN A.INDEXAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH A,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE      A.INDEXAUTH IN ('Y', 'G')      AND T.TYPE = 'A'      AND B.BASESCHEMA = A.TCREATOR      AND B.BASENAME = A.TTNAME UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('INSERT' AS VARCHAR(10)),       CAST(CASE                                         WHEN A.INSERTAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH A,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE      A.INSERTAUTH IN ('Y', 'G')   AND T.TYPE = 'A'      AND B.BASESCHEMA = A.TCREATOR      AND B.BASENAME = A.TTNAME UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('REFERENCES' AS VARCHAR(10)),                              CAST(CASE                                                         WHEN A.REFAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH A,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE      A.REFAUTH IN ('Y', 'G')    AND T.TYPE = 'A'      AND B.BASESCHEMA = A.TCREATOR      AND B.BASENAME = A.TTNAME UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('SELECT' AS VARCHAR(10)),       CAST(CASE                                         WHEN A.SELECTAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH A,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE      A.SELECTAUTH IN ('Y', 'G')      AND T.TYPE = 'A'      AND B.BASESCHEMA = A.TCREATOR      AND B.BASENAME = A.TTNAME UNION  SELECT    CAST( NULL AS VARCHAR(128) ),    RTRIM(T.CREATOR),    T.NAME,    RTRIM(A.GRANTOR),    RTRIM(A.GRANTEE),    CAST('UPDATE' AS VARCHAR(10)),       CAST(CASE                                         WHEN A.UPDATEAUTH='G' THEN 'YES' ELSE 'NO'    END AS VARCHAR(3)),    CAST( NULL AS VARCHAR(8) )  FROM    SYSIBM.SYSTABAUTH A,    SYSIBM.SYSTABLES T,    TABLE(SYSPROC.BASE_TABLE(T.CREATOR, T.NAME)) AS B  WHERE      A.UPDATEAUTH IN ('Y', 'G')      AND T.TYPE = 'A'      AND B.BASESCHEMA = A.TCREATOR      AND B.BASENAME = A.TTNAME;

-- View: SYSIBM.SQLTABLES
CREATE VIEW SYSIBM.SQLTABLES AS CREATE OR REPLACE VIEW SYSIBM.SQLTABLES (     TABLE_CAT,     TABLE_SCHEM,     TABLE_NAME,     TABLE_TYPE,     REMARKS,     TYPE_CAT,     TYPE_SCHEM,     TYPE_NAME,     SELF_REF_COL_NAME,     REF_GENERATION,     DBNAME ) AS   SELECT     CAST( NULL AS VARCHAR(128) ),     RTRIM(T.CREATOR),     T.NAME,     CASE       WHEN T.TYPE='T' AND T.CREATOR='SYSIBM' THEN 'SYSTEM TABLE'       WHEN T.TYPE='T' AND T.CREATOR<>'SYSIBM' THEN 'TABLE'       WHEN T.TYPE='V' AND T.STATUS<>'X' THEN 'VIEW'       WHEN T.TYPE='V' AND T.STATUS='X' THEN 'INOPERATIVE VIEW'       WHEN T.TYPE='X' THEN NULL       ELSE TT.TABLE_TYPE     END,     T.REMARKS,     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(128) ),     CAST( NULL AS VARCHAR(8) )   FROM     SYSIBM.SYSTABLES T,     SYSIBM.SQLTABLETYPES TT   WHERE     T.TYPE = TT.TYPE;

-- View: SYSIBM.SQLTABLETYPES
CREATE VIEW SYSIBM.SQLTABLETYPES AS CREATE OR REPLACE VIEW SYSIBM.SQLTABLETYPES (   TABLE_CAT,   TABLE_SCHEM,   TABLE_NAME,   TABLE_TYPE,   REMARKS,   TYPE_CAT,   TYPE_SCHEM,   TYPE_NAME,   SELF_REF_COL_NAME,   REF_GENERATION,   DBNAME,   TYPE ) AS   VALUES     ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'ALIAS', 128),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( 'A', 1 ) ),  ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'HIERARCHY TABLE', 128),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( 'H', 1 ) ),     ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'INOPERATIVE VIEW', 128),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( '?', 1 ) ),  ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'NICKNAME', 128 ),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( 'N', 1 ) ),     ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'MATERIALIZED QUERY TABLE', 128),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( 'S', 1 ) ),     ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'SYSTEM TABLE', 128),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( '?', 1 ) ),     ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'TABLE', 128),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( 'T', 1 ) ),     ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'TYPED TABLE', 128),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( 'U', 1 ) ),  ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'TYPED VIEW', 128),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( 'W', 1 ) ),     ( CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       VARCHAR( 'VIEW', 128),       CAST( NULL AS VARCHAR(254) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(128) ),       CAST( NULL AS VARCHAR(8) ),       CHAR( 'V', 1 ) );

-- View: SYSIBM.SQLTYPEINFO
CREATE VIEW SYSIBM.SQLTYPEINFO AS CREATE OR REPLACE VIEW SYSIBM.SQLTYPEINFO  (TYPE_NAME,   DATA_TYPE,   COLUMN_SIZE,   LITERAL_PREFIX,   LITERAL_SUFFIX,   CREATE_PARAMS,   NULLABLE,   CASE_SENSITIVE,   SEARCHABLE,   UNSIGNED_ATTRIBUTE,   FIXED_PREC_SCALE,   AUTO_UNIQUE_VALUE,   LOCAL_TYPE_NAME,   MINIMUM_SCALE,   MAXIMUM_SCALE,   SQL_DATA_TYPE,   SQL_DATETIME_SUB,   NUM_PREC_RADIX,   INTERVAL_PRECISION,   JDBC_DATA_TYPE ) AS  VALUES   ( VARCHAR( 'INTEGER', 128 ),     SMALLINT(4),     10,     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     SMALLINT(0),     SMALLINT(1),     SMALLINT(0),     CAST(NULL AS VARCHAR(128)),     SMALLINT(0),     SMALLINT(0),     4,     CAST(NULL AS INTEGER),     10,     CAST(NULL AS SMALLINT),     SMALLINT(4) ),   ( 'SMALLINT',     SMALLINT(5),     5,     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     SMALLINT(0),     SMALLINT(1),     SMALLINT(0),     CAST(NULL AS VARCHAR(128)),     SMALLINT(0),     SMALLINT(0),     5,     CAST(NULL AS INTEGER),     10,     CAST(NULL AS SMALLINT),     SMALLINT(5) ),   ( 'BIGINT',     SMALLINT(-5),     20,     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     SMALLINT(0),     SMALLINT(1),     SMALLINT(0),     CAST(NULL AS VARCHAR(128)),     SMALLINT(0),     SMALLINT(0),     -5,     CAST(NULL AS INTEGER),     10,     CAST(NULL AS SMALLINT),     SMALLINT(-5) ),   ( 'REAL',     SMALLINT(7),     24,     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     SMALLINT(0),     SMALLINT(0),     SMALLINT(0),     CAST(NULL AS VARCHAR(128)),     SMALLINT(0),     SMALLINT(0),     7,     CAST(NULL AS INTEGER),     2,     CAST(NULL AS SMALLINT),     SMALLINT(7) ),   ( 'DOUBLE',     SMALLINT(8),     53,     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     SMALLINT(0),     SMALLINT(0),     SMALLINT(0),     CAST(NULL AS VARCHAR(128)),     SMALLINT(0),     SMALLINT(0),     8,     CAST(NULL AS INTEGER),     2,     CAST(NULL AS SMALLINT),     SMALLINT(8) ),   ( 'CHAR',     SMALLINT(1),     255,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(1),     SMALLINT(3),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     1,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(1) ),   ( 'VARCHAR',     SMALLINT(12),     4000,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(1),     SMALLINT(3),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     12,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(12) ),   ( 'LONG VARCHAR',     SMALLINT(-1),     32700,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(1),     SMALLINT(1),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -1,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(-1) ),   ( 'DECIMAL',     SMALLINT(3),     31,     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST('PRECISION,SCALE' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     SMALLINT(0),     SMALLINT(0),     SMALLINT(0),     CAST(NULL AS VARCHAR(128)),     SMALLINT(0),     SMALLINT(31),     3,     CAST(NULL AS INTEGER),     10,     CAST(NULL AS SMALLINT),     SMALLINT(3) ),   ( 'GRAPHIC',     SMALLINT(-95),     127,     CAST('G''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(3),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -95,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(1) ),   ( 'VARGRAPHIC',     SMALLINT(-96),     16336,     CAST('G''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(3),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -96,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(12) ),   ( 'LONG VARGRAPHIC',     SMALLINT(-97),     16350,     CAST('G''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(1),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -97,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(-1) ),   ( 'BLOB',     SMALLINT(-98),     2147483647,     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(1),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -98,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(2004) ),   ( 'CLOB',     SMALLINT(-99),     2147483647,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(1),     SMALLINT(1),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -99,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(2005) ),   ( 'DBCLOB',     SMALLINT(-350),     1073741823,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(1),     SMALLINT(1),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -350,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(2005) ),   ( 'DATE',     SMALLINT(91),     10,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     9,     1,     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(91) ),   ( 'TIME',     SMALLINT(92),     8,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(0 AS SMALLINT),     CAST(0 AS SMALLINT),     9,     2,     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(92) ),   ( 'TIMESTAMP',     SMALLINT(93),     32,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(0 AS SMALLINT),     CAST(12 AS SMALLINT),     9,     3,     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(93) ),   ( 'DATALINK',     SMALLINT(-400),     254,     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(0),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -400,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(70) ),   ( 'LONG VARCHAR FOR BIT DATA',     SMALLINT(-4),     32700,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(0),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -4,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(-4) ),   ( 'VARCHAR () FOR BIT DATA',     SMALLINT(-3),     32762,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(3),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -3,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(-3) ),   ( 'CHAR () FOR BIT DATA',     SMALLINT(-2),     255,     CAST('''' AS VARCHAR(128)),     CAST('''' AS VARCHAR(128)),     CAST('LENGTH' AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(3),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -2,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(-2) ),   ( 'DISTINCT',     SMALLINT(2001),     CAST(NULL AS INTEGER),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(2001) ),   ( 'XML',     SMALLINT(-370),     CAST(NULL AS INTEGER),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(1),     SMALLINT(0),     CAST(NULL AS SMALLINT),     SMALLINT(0),     CAST(NULL AS SMALLINT),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS SMALLINT),     CAST(NULL AS SMALLINT),     -370,     CAST(NULL AS INTEGER),     CAST(NULL AS INTEGER),     CAST(NULL AS SMALLINT),     SMALLINT(1111) ),   ( 'BOOLEAN',     SMALLINT(16),     1,     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     CAST(NULL AS VARCHAR(128)),     SMALLINT(1),     SMALLINT(0),     SMALLINT(2),     SMALLINT(0),     SMALLINT(1),     SMALLINT(0),     CAST(NULL AS VARCHAR(128)),     SMALLINT(0),     SMALLINT(0),     16,     CAST(NULL AS INTEGER),     1,     CAST(NULL AS SMALLINT),     SMALLINT(16) );

-- View: SYSIBM.SQLUDTS
CREATE VIEW SYSIBM.SQLUDTS AS CREATE OR REPLACE VIEW SYSIBM.SQLUDTS (     TYPE_CAT,     TYPE_SCHEM,     TYPE_MODULE,     TYPE_NAME,     CLASS_NAME,     DATA_TYPE,     BASE_TYPE,     REMARKS )   AS    SELECT      CAST( NULL AS VARCHAR(128) ),     RTRIM(schema),     (SELECT modulename FROM SYSIBM.SYSMODULES WHERE moduleid=typemoduleid),     name,     CAST( CASE      WHEN metatype in ('A','L') THEN 'java.sql.Array'      WHEN sourcetype='INTEGER' THEN 'java.lang.Integer'      WHEN sourcetype='SMALLINT' THEN 'java.lang.Short'      WHEN sourcetype='BIGINT' THEN 'java.lang.Long'      WHEN sourcetype='REAL' THEN 'java.lang.Float'      WHEN sourcetype='DOUBLE' THEN 'java.lang.Double'      WHEN sourcetype='DECFLOAT' THEN 'java.math.BigDecimal'      WHEN sourcetype='CHARACTER' AND b.CODEPAGE <> 0 THEN 'java.lang.String'      WHEN sourcetype='CHARACTER' AND b.CODEPAGE = 0  THEN 'byte[]'      WHEN sourcetype='VARCHAR' AND b.CODEPAGE <> 0 THEN 'java.lang.String'      WHEN sourcetype='VARCHAR' AND b.CODEPAGE = 0 THEN 'byte[]'      WHEN sourcetype='DECIMAL' THEN 'java.math.BigDecimal'      WHEN sourcetype='NUMERIC' THEN 'java.math.BigDecimal'      WHEN sourcetype='GRAPHIC' THEN 'java.lang.String'      WHEN sourcetype='VARGRAPHIC'  THEN 'java.lang.String'      WHEN sourcetype='BINARY' THEN 'byte[]'      WHEN sourcetype='VARBINARY' THEN 'byte[]'      WHEN sourcetype='BLOB' THEN 'java.sql.Blob'      WHEN sourcetype='CLOB' THEN 'java.sql.Clob'      WHEN sourcetype='DBCLOB' THEN 'java.sql.Clob'      WHEN sourcetype='DATE' THEN 'java.sql.Date'      WHEN sourcetype='TIME' THEN 'java.sql.Time'      WHEN sourcetype='TIMESTAMP' THEN 'java.sql.Timestamp'      WHEN sourcetype='ROWID'   THEN 'byte[]'      WHEN sourcetype='DATALINK' THEN 'java.net.URL'      WHEN sourcetype IS NULL and metatype='C' THEN 'java.sql.ResultSet'      ELSE ''    END AS VARCHAR(30)),     SMALLINT( CASE      WHEN metatype IN ('T','C') THEN 2001      WHEN metatype='R' THEN 2002      WHEN metatype='A' THEN 2003      WHEN metatype='L' THEN 1111    END),    SMALLINT(CASE       WHEN sourcetype='INTEGER'  THEN 4       WHEN sourcetype='SMALLINT' THEN 5      WHEN sourcetype='BIGINT' THEN -5      WHEN sourcetype='REAL' THEN 7      WHEN sourcetype='DOUBLE' THEN 8      WHEN sourcetype='DECFLOAT' THEN 1111      WHEN sourcetype='CHARACTER' AND b.CODEPAGE <> 0 THEN 1      WHEN sourcetype='CHARACTER' AND b.CODEPAGE = 0 THEN -2      WHEN sourcetype='VARCHAR' AND b.CODEPAGE <> 0 THEN 12      WHEN sourcetype='VARCHAR' AND b.CODEPAGE = 0 THEN -3      WHEN sourcetype='DECIMAL' THEN 3      WHEN sourcetype='NUMERIC' THEN 2      WHEN sourcetype='GRAPHIC' THEN 1      WHEN sourcetype='VARGRAPHIC' THEN 12      WHEN sourcetype='BLOB' THEN 2004      WHEN sourcetype='CLOB' THEN 2005      WHEN sourcetype='DBCLOB' THEN 2005      WHEN sourcetype='DATE' THEN 91      WHEN sourcetype='TIME' THEN 92      WHEN sourcetype='TIMESTAMP' THEN 93      WHEN sourcetype='ROWID' THEN 1111      WHEN sourcetype='DATALINK' THEN 70      WHEN sourcetype='BINARY' THEN -2      WHEN sourcetype='VARBINARY' THEN -3      WHEN sourcetype IS NULL AND metatype='C' THEN 1111      ELSE 0    END),    remarks   FROM     SYSIBM.SYSDATATYPES B   WHERE     metatype IN ('A','C','L','R','T');

-- View: SYSIBM.SYSDUMMY1
CREATE VIEW SYSIBM.SYSDUMMY1 AS create view sysibm.sysdummy1 (ibmreqd) as values (char('Y')) 

;

-- View: SYSIBM.SYSFUNCPARMS
CREATE VIEW SYSIBM.SYSFUNCPARMS AS create or replace view sysibm.sysfuncparms 
(fname, fschema, fspecific, rowtype, ordinal, 
typename, typeschema, length, scale, codepage, cast_function_id, 
parmname, as_locator, target_typeschema, target_typename, 
scope_tabschema, scope_tabname, transform_grpname) 
as select 
routinename, routineschema, specificname, rowtype, ordinal, 
typename, typeschema, length, scale, codepage, cast_function_id, 
parmname, locator, target_typeschema, target_typename, 
scope_tabschema, scope_tabname, transform_grpname 
from sysibm.sysroutineparms 
where routinetype in ('F', 'M') 
and routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSIBM.SYSFUNCTIONS
CREATE VIEW SYSIBM.SYSFUNCTIONS AS CREATE OR REPLACE view sysibm.sysfunctions 
(name, schema, definer, specific, parm_signature, function_id, 
return_type, origin, type, create_time, parm_count, variant, 
side_effects, fenced, nullcall, cast_function, assign_function, 
scratchpad, final_call,language, implementation, source_specific, 
source_schema, ios_per_invoc, insts_per_invoc, ios_per_argbyte, 
insts_per_argbyte, percent_argbytes, initial_ios, initial_insts, 
internal_prec1, internal_prec2, remarks, internal_desc, parallelizable, 
contains_sql, dbinfo, result_cols, body, cardinality, parm_style, 
method, implemented, effect, func_path, type_preserving, 
with_func_access, selectivity, overridden_funcid, subject_typeschema, 
subject_typename, qualifier, class, jar_id) 
as select 
a.routinename, a.routineschema, a.definer, a.specificname, 
a.parm_signature, a.routine_id, 
a.return_type, a.origin, a.function_type, a.createdts, a.parm_count, 
CAST 
(CASE a.deterministic 
WHEN 'Y' THEN 'N' 
WHEN 'N' THEN 'Y' 
ELSE ' ' END AS CHAR(1)), 
a.external_action, a.fenced, a.null_call, a.cast_function, 
a.assign_function, a.scratchpad, a.final_call, a.language, 
a.implementation, a.sourcespecific, a.sourceschema, a.ios_per_invoc, 
a.insts_per_invoc, a.ios_per_argbyte, a.insts_per_argbyte, 
a.percent_argbytes, a.initial_ios, a.initial_insts, a.internal_prec1, 
a.internal_prec2, a.remarks, a.internal_desc, a.parallel, 
a.sql_data_access, a.dbinfo, a.result_cols, a.text, a.cardinality, 
a.parameter_style, 
CAST 
(CASE a.routinetype 
WHEN 'M' THEN 'Y' ELSE 'N' END AS CHAR(1)), 
CASE 
WHEN a.routinetype = 'F' THEN 'Y' 
WHEN a.methodimplemented = 'N' AND a.with_func_access = 'N' THEN 'A' 
WHEN a.methodimplemented = 'Y' AND a.with_func_access = 'Y' THEN 'H' 
WHEN a.methodimplemented = 'Y' AND a.with_func_access = 'N' THEN 'M' 
ELSE ' ' 
END as methodimplemented, 
a.methodeffect, a.func_path, 
CAST 
(CASE 
WHEN a.type_preserving = 'Y' THEN 'Y' 
ELSE 'N' 
END AS CHAR(1)), 
CASE a.routinetype 
WHEN 'F' THEN 'Y' 
ELSE a.routinetype 
END as with_func_access, 
a.selectivity, a.overridden_methodid, 
a.subject_typeschema, a.subject_typename, a.qualifier, 
CASE 
WHEN a.language <> 'JAVA' THEN NULL 
ELSE 
(SELECT pj.class FROM 
SYSIBM.SYSROUTINEPROPERTIES AS pj 
WHERE pj.routine_id = a.routine_id) 
END, 
CASE 
WHEN a.language <> 'JAVA' THEN NULL 
ELSE 
(SELECT pj.jar_id FROM 
SYSIBM.SYSROUTINEPROPERTIES AS pj 
WHERE pj.routine_id = a.routine_id) 
END 
from sysibm.sysroutines as a 
where a.routinetype in ('F', 'M') 
and a.routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSIBM.SYSPROCEDURES
CREATE VIEW SYSIBM.SYSPROCEDURES AS create or replace view sysibm.sysprocedures 
(procschema, procname, specificname, procedure_id, definer, 
parm_count, parm_signature, origin, create_time, fenced, 
nullcall, language, implementation, parm_style, result_sets, remarks, 
deterministic, packed_desc, contains_sql, dbinfo, program_type, 
valid, class, jar_id, text_body_offset, text) 
as select 
a.routineschema, a.routinename, a.specificname, a.routine_id, a.definer, 
a.parm_count, a.parm_signature, a.origin, a.createdts, a.fenced, 
a.null_call, a.language, a.implementation, a.parameter_style, 
a.result_sets, a.remarks, a.deterministic, a.internal_desc, 
a.sql_data_access, a.dbinfo, a.program_type, a.valid, 
CASE 
WHEN a.language <> 'JAVA' THEN NULL 
ELSE 
(SELECT pj.class 
FROM SYSIBM.SYSROUTINEPROPERTIES AS pj 
WHERE pj.routine_id = a.routine_id) 
END, 
CASE 
WHEN a.language <> 'JAVA' THEN NULL 
ELSE 
(SELECT pj.jar_id 
FROM SYSIBM.SYSROUTINEPROPERTIES AS pj 
WHERE pj.routine_id = a.routine_id) 
END, 
a.text_body_offset, a.text 
from sysibm.sysroutines as a 
where a.routinetype in ('P') 
and a.routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSIBM.SYSPROCPARMS
CREATE VIEW SYSIBM.SYSPROCPARMS AS create or replace view sysibm.sysprocparms 
(procschema, procname, specificname, ordinal, parmname, 
typeschema, typename, length, scale, codepage, 
parm_mode, 
as_locator, target_typeschema, target_typename, 
scope_tabschema, scope_tabname, typeid, 
sourcetypeid, servername, dbcs_codepage, nulls) 
as select 
routineschema, routinename, specificname, ordinal, parmname, typeschema, 
typename, length, scale, codepage, 
CAST 
(CASE rowtype 
WHEN 'P' THEN 'IN' 
WHEN 'O' THEN 'OUT' 
ELSE 'INOUT' 
END AS VARCHAR(5)) , 
locator, target_typeschema, target_typename, scope_tabschema, 
scope_tabname, typeid, CAST(null as smallint),CAST(null as varchar(128)), 
CAST(null as smallint), CAST('Y' as char(1)) 
from sysibm.sysroutineparms 
where routinetype in ('P') 
and routineschema not in ('SYSIBMINTERNAL')
;

-- View: SYSIBM.SYSREVTYPEMAPPINGS
CREATE VIEW SYSIBM.SYSREVTYPEMAPPINGS AS create or replace view sysibm.sysrevtypemappings 
(type_mapping, typeschema, typename, typeid, sourcetypeid, 
definer, lower_len, upper_len, lower_scale, upper_scale, 
s_opr_p, bit_data, wrapname, 
servername, servertype, serverversion, remote_typeschema, 
remote_typename, remote_meta_type, remote_length, 
remote_scale, 
remote_bit_data, user_defined, create_time, 
remarks) 
as select 
type_mapping, typeschema, typename, typeid, sourcetypeid, definer, 
lower_len, upper_len, lower_scale, upper_scale, s_opr_p, bit_data, 
wrapname, servername, servertype, serverversion, remote_typeschema, 
remote_typename, remote_meta_type, remote_lower_len, remote_lower_scale, 
remote_bit_data, user_defined, create_time, remarks 
from sysibm.systypemappings
;

-- View: SYSIBM.SYSROUTINEPROPERTIESJAVA
CREATE VIEW SYSIBM.SYSROUTINEPROPERTIESJAVA AS create or replace view sysibm.sysroutinepropertiesjava 
(routine_id, class, jar_id, jarschema, jar_signature) 
as select 
routine_id, class, jar_id, jarschema, jar_signature 
from sysibm.sysroutineproperties
;

-- View: SYSIBM.TABLES
CREATE VIEW SYSIBM.TABLES AS CREATE OR REPLACE VIEW SYSIBM.TABLES 
( 
TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, 
SELF_REFERENCING_COLUMN_NAME, REFERENCE_GENERATION, 
USER_DEFINED_TYPE_CATALOG, USER_DEFINED_TYPE_SCHEMA, 
USER_DEFINED_TYPE_NAME ,  IS_INSERTABLE_INTO 
)  AS 
WITH T_ALIAS (A_SCHEMA, A_NAME, B_SCHEMA, B_NAME, NUM) AS 
( 
SELECT CREATOR, NAME, BASE_SCHEMA, BASE_NAME, 1 
FROM        SYSIBM.SYSTABLES T 
WHERE  T.TYPE='A' 
UNION ALL 
SELECT  A_SCHEMA, A_NAME, BASE_SCHEMA, BASE_NAME, NUM+1 
FROM T_ALIAS, 
SYSIBM.SYSTABLES 
WHERE B_SCHEMA = CREATOR 
AND B_NAME = NAME 
AND NUM <= 128 
), 
T_ALIAS2 (A2_SCHEMA, A2_NAME, READONLY) AS 
( 
SELECT A_SCHEMA, A_NAME, READONLY 
FROM     T_ALIAS, SYSIBM.SYSVIEWS 
WHERE B_SCHEMA = CREATOR 
AND B_NAME = NAME 
) 
SELECT CAST(CURRENT SERVER AS VARCHAR(128)), 
T.CREATOR , 
T.NAME , 
CASE  TYPE 
WHEN 'A' THEN 'ALIAS' 
WHEN 'H' THEN 'HIERARCHY TABLE' 
WHEN 'J' THEN 'HIERARCHY VIEW' 
WHEN 'S' THEN 'MATERIALIZED QUERY TABLE' 
WHEN 'T' THEN 'BASE TABLE' 
WHEN 'U' THEN 'TYPED TABLE' 
WHEN 'V' THEN 'VIEW' 
WHEN 'W' THEN 'TYPED VIEW' ELSE CAST('' AS VARCHAR(128)) 
END , 
P.COLNAME, 
CASE SUBSTR(P.SPECIAL_PROPS,2,1) 
WHEN 'U' THEN  'USER GENERATED' 
WHEN 'S' THEN  'SYSTEM GENERATED' 
ELSE CAST(NULL AS VARCHAR(16)) 
END, 
CASE 
WHEN T.TYPE IN ('U', 'W') THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN T.TYPE IN ('U', 'W') THEN  ROWTYPESCHEMA 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN T.TYPE IN ('U', 'W') THEN CAST(ROWTYPENAME AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END, 
CASE 
WHEN TYPE='A' AND (A2.READONLY='N' OR A2.READONLY  IS NULL) 
THEN 'YES' 
WHEN TYPE='A' AND A2.READONLY='Y' THEN 'NO' 
WHEN TYPE='G' THEN 'YES' 
WHEN TYPE='H' THEN 'NO' 
WHEN TYPE='J' THEN 'NO' 
WHEN TYPE='S' AND SUBSTR(PROPERTY,1,1)<>'Y' THEN 'NO' 
WHEN TYPE='S' AND SUBSTR(PROPERTY,1,1) ='Y' THEN 'YES' 
WHEN TYPE='T' THEN 'YES' 
WHEN TYPE='U' THEN 'YES' 
WHEN TYPE IN ('V','W') AND V.READONLY='Y' THEN 'NO' 
WHEN TYPE IN ('V','W') AND V.READONLY='N' THEN 'YES' ELSE 'NO' 
END 
FROM ( SYSIBM.SYSTABLES  T 
LEFT OUTER JOIN 
SYSIBM.SYSCOLPROPERTIES P 
ON (T.CREATOR, T.NAME) = (P.TABSCHEMA, P.TABNAME) 
AND SUBSTR(P.SPECIAL_PROPS,1,1) = 'Y' 
) 
LEFT OUTER JOIN 
SYSIBM.SYSVIEWS V 
ON (T.CREATOR, T.NAME) = (V.CREATOR, V.NAME) 
LEFT OUTER JOIN 
T_ALIAS2 A2 
ON (T.CREATOR, T.NAME) = (A2_SCHEMA, A2_NAME)
;

-- View: SYSIBM.TABLES_S
CREATE VIEW SYSIBM.TABLES_S AS CREATE OR REPLACE VIEW SYSIBM.TABLES_S 
( 
TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, 
TABLE_TYPE,  SELF_REF_COL_NAME, REF_GENERATION, 
UDT_CATALOG, UDT_SCHEMA,  UDT_NAME,  IS_INSERTABLE_INTO 
)  AS 
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, 
SELF_REFERENCING_COLUMN_NAME, REFERENCE_GENERATION, 
USER_DEFINED_TYPE_CATALOG, USER_DEFINED_TYPE_SCHEMA, 
USER_DEFINED_TYPE_NAME ,  IS_INSERTABLE_INTO 
FROM SYSIBM.TABLES
;

-- View: SYSIBM.TABLE_CONSTRAINTS
CREATE VIEW SYSIBM.TABLE_CONSTRAINTS AS CREATE OR REPLACE VIEW SYSIBM.TABLE_CONSTRAINTS 
( 
CONSTRAINT_CATALOG, CONSTRAINT_SCHEMA, CONSTRAINT_NAME, 
TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, 
CONSTRAINT_TYPE, IS_DEFERRABLE, INITIALLY_DEFERRED 
) AS 
SELECT CAST(CURRENT SERVER  AS VARCHAR(128)), 
TBCREATOR , 
CAST(NAME    AS VARCHAR(128)), 
CAST(CURRENT SERVER AS VARCHAR(128)), 
TBCREATOR , 
TBNAME, 
CASE CONSTRAINTYP 
WHEN 'K' THEN  'CHECK' 
WHEN 'P' THEN ' PRIMARY KEY' 
WHEN 'F' THEN ' FOREIGN KEY' 
WHEN 'U' THEN ' UNIQUE' 
END , 
CAST('NO' AS VARCHAR(2))  ,  CAST('NO' AS VARCHAR(2)) 
FROM   SYSIBM.SYSTABCONST 
UNION ALL 
SELECT  CAST(CURRENT SERVER AS VARCHAR(128)), 
TBCREATOR, 
CAST(CONCAT(SUBSTR(HEX(CTIME),5), 
CONCAT(HEX(COLNO), 
CONCAT(HEX(FID),HEX(TID)))) 
AS VARCHAR(128) ), 
CAST(CURRENT SERVER AS VARCHAR(128)), 
TBCREATOR, 
TBNAME, 
'CHECK', 
CAST('NO' AS VARCHAR(2)), CAST('NO' AS VARCHAR(2)) 
FROM SYSIBM.SYSCOLUMNS C, SYSIBM.SYSTABLES T 
WHERE   C.TBCREATOR = T.CREATOR 
AND C.TBNAME = T.NAME 
AND TYPE IN ('U', 'T') 
AND NULLS ='N'
;

-- View: SYSIBM.UDT_S
CREATE VIEW SYSIBM.UDT_S AS CREATE OR REPLACE VIEW SYSIBM.UDT_S 
( 
UDT_CATALOG, UDT_SCHEMA, UDT_NAME, UDT_CATEGORY, 
IS_INSTANTIABLE, IS_FINAL, ORDERING_FORM, ORDERING_CATEGORY, 
ORDERING_ROUT_CAT , ORDERING_ROUT_SCH , ORDERING_ROUT_NAME, 
REFERENCE_TYPE, DATA_TYPE, CHAR_MAX_LENGTH, CHAR_OCTET_LENGTH, 
CHAR_SET_CATALOG, CHAR_SET_SCHEMA, CHARACTER_SET_NAME, 
COLLATION_CATALOG, COLLATION_SCHEMA, COLLATION_NAME, 
NUMERIC_PRECISION, NUMERIC_PREC_RADIX, NUMERIC_SCALE, 
DATETIME_PRECISION, INTERVAL_TYPE, INTERVAL_PRECISION, 
SOURCE_DTD_ID, REF_DTD_IDENTIFIER 
) AS 
SELECT USER_DEFINED_TYPE_CATALOG, USER_DEFINED_TYPE_SCHEMA, 
USER_DEFINED_TYPE_NAME, USER_DEFINED_TYPE_CATEGORY, 
IS_INSTANTIABLE, IS_FINAL, ORDERING_FORM, ORDERING_CATEGORY, 
ORDERING_ROUTINE_CATALOG, ORDERING_ROUTINE_SCHEMA, 
ORDERING_ROUTINE_NAME, REFERENCE_TYPE, DATA_TYPE, 
CHARACTER_MAXIMUM_LENGTH, CHARACTER_OCTET_LENGTH, 
CHARACTER_SET_CATALOG, CHARACTER_SET_SCHEMA, 
CHARACTER_SET_NAME, COLLATION_CATALOG, COLLATION_SCHEMA, 
COLLATION_NAME, NUMERIC_PRECISION, NUMERIC_PRECISION_RADIX, 
NUMERIC_SCALE, DATETIME_PRECISION, INTERVAL_TYPE, 
INTERVAL_PRECISION, SOURCE_DTD_IDENTIFIER, REF_DTD_IDENTIFIER 
FROM SYSIBM.USER_DEFINED_TYPES
;

-- View: SYSIBM.USER_DEFINED_TYPES
CREATE VIEW SYSIBM.USER_DEFINED_TYPES AS CREATE OR REPLACE VIEW SYSIBM.USER_DEFINED_TYPES AS 
SELECT CAST(CURRENT SERVER AS VARCHAR(128)) AS USER_DEFINED_TYPE_CATALOG, 
D.SCHEMA AS USER_DEFINED_TYPE_SCHEMA, 
CAST(D.NAME AS VARCHAR(128)) AS USER_DEFINED_TYPE_NAME, 
CASE D.METATYPE 
WHEN 'T'  THEN 'DISTINCT' 
WHEN 'R' THEN  'STRUCTURED' 
END AS USER_DEFINED_TYPE_CATEGORY, 
CASE D.INSTANTIABLE 
WHEN 'Y'  THEN 'YES' 
WHEN 'N'  THEN 'NO' 
END AS IS_INSTANTIABLE, 
CASE D.FINAL 
WHEN 'Y'  THEN 'YES' 
WHEN 'N' THEN 'NO' 
END AS IS_FINAL, 
CASE 
WHEN D.METATYPE='R' OR (D.METATYPE='T' AND 
D.SOURCETYPE IN ('BLOB','CLOB','DBCLOB','LONG VARCHAR', 
'LONG VARGRAPHIC','DATALINK')) 
THEN CAST('NONE' AS VARCHAR(6)) ELSE 'FULL' 
END AS ORDERING_FORM, 
CASE D.METATYPE 
WHEN 'R' THEN 'STATE'  ELSE CAST('MAP' AS VARCHAR(5)) 
END AS ORDERING_CATEGORY, 
CASE 
WHEN D.METATYPE='R' OR (D.METATYPE='T' AND 
D.SOURCETYPE IN ('BLOB','CLOB','DBCLOB','LONG VARCHAR', 
'LONG VARGRAPHIC','DATALINK') )  THEN CAST(NULL AS VARCHAR(128)) 
ELSE CURRENT SERVER 
END AS ORDERING_ROUTINE_CATALOG, 
CASE 
WHEN D.METATYPE='R' OR (D.METATYPE='T' AND 
D.SOURCETYPE IN ('BLOB','CLOB','DBCLOB','LONG VARCHAR', 
'LONG VARGRAPHIC','DATALINK') ) THEN CAST(NULL AS VARCHAR(128)) 
ELSE D.SOURCESCHEMA 
END AS ORDERING_ROUTINE_SCHEMA, 
CASE 
WHEN D.METATYPE='R' OR (D.METATYPE='T' AND 
D.SOURCETYPE IN ('BLOB','CLOB','DBCLOB','LONG VARCHAR', 
'LONG VARGRAPHIC','DATALINK') )  THEN CAST(NULL AS VARCHAR(128)) 
ELSE D.SOURCETYPE 
END AS ORDERING_ROUTINE_NAME, 
CASE D.METATYPE 
WHEN 'R'    THEN 'USER GENERATED' ELSE CAST(NULL AS VARCHAR(16)) 
END AS REFERENCE_TYPE, 
CASE 
WHEN D.SOURCETYPE ='CHARACTER'       THEN 'CHARACTER' 
WHEN D.SOURCETYPE ='VARCHAR'         THEN 'CHARACTER VARYING' 
WHEN D.SOURCETYPE ='LONG VARCHAR'    THEN 'LONG VARCHAR' 
WHEN D.SOURCETYPE ='INTEGER'         THEN 'INTEGER' 
WHEN D.SOURCETYPE ='SMALLINT'        THEN 'SMALLINT' 
WHEN D.SOURCETYPE ='BIGINT'          THEN 'BIGINT' 
WHEN D.SOURCETYPE ='REAL'            THEN 'REAL' 
WHEN D.SOURCETYPE ='DOUBLE'          THEN 'DOUBLE PRECISION' 
WHEN D.SOURCETYPE ='DECIMAL'         THEN 'DECIMAL' 
WHEN D.SOURCETYPE ='BLOB'            THEN 'BINARY LARGE OBJECT' 
WHEN D.SOURCETYPE ='CLOB'            THEN 'CHARACTER LARGE OBJECT' 
WHEN D.SOURCETYPE ='DBCLOB'  THEN 'DOUBLE-BYTE CHARACTER LARGE OBJECT' 
WHEN D.SOURCETYPE ='GRAPHIC'         THEN 'GRAPHIC' 
WHEN D.SOURCETYPE ='VARGRAPHIC'      THEN 'GRAPHIC VARYING' 
WHEN D.SOURCETYPE ='LONG VARGRAPHIC' THEN 'LONG VARGRAPHIC' 
WHEN D.SOURCETYPE ='DATALINK'        THEN 'DATALINK' 
WHEN D.SOURCETYPE ='TIME'            THEN 'TIME' 
WHEN D.SOURCETYPE ='DATE'            THEN 'DATE' 
WHEN D.SOURCETYPE ='TIMESTAMP'       THEN 'TIMESTAMP' 
ELSE D.SOURCETYPE 
END 
AS DATA_TYPE, 
CASE 
WHEN D.SOURCETYPE IN ('CHARACTER', 'VARCHAR', 'LONG VARCHAR', 
'CLOB', 'BLOB', 'DBCLOB', 
'GRAPHIC', 'VARGRAPHIC', 'LONG VARGRAPHIC') THEN D.LENGTH 
ELSE CAST(NULL AS INTEGER) 
END AS CHARACTER_MAXIMUM_LENGTH, 
CASE 
WHEN D.SOURCETYPE IN ('CHARACTER', 'VARCHAR', 'LONG VARCHAR', 
'CLOB', 'BLOB') THEN D.LENGTH 
WHEN D.SOURCETYPE IN ('DBCLOB', 'GRAPHIC', 
'VARGRAPHIC', 'LONG VARGRAPHIC') THEN D.LENGTH*2 
ELSE CAST(NULL AS INTEGER) 
END AS CHARACTER_OCTET_LENGTH, 
CASE 
WHEN D.SOURCETYPE IN ('CHARACTER', 'VARCHAR', 'LONG VARCHAR', 
'CLOB', 'DBCLOB', 'GRAPHIC', 
'VARGRAPHIC', 'LONG VARGRAPHIC') 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END AS CHARACTER_SET_CATALOG, 
CASE 
WHEN D.SOURCETYPE IN ('CHARACTER', 'VARCHAR', 'LONG VARCHAR', 
'CLOB', 'DBCLOB', 'GRAPHIC', 
'VARGRAPHIC', 'LONG VARGRAPHIC') 
THEN CAST('SYSIBM' AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END AS CHARACTER_SET_SCHEMA, 
CASE 
WHEN D.SOURCETYPE IN ('CHARACTER', 'VARCHAR', 'LONG VARCHAR', 
'CLOB', 'DBCLOB', 'GRAPHIC', 
'VARGRAPHIC', 'LONG VARGRAPHIC') 
THEN CAST(CONCAT('IBM', CHAR(D.CODEPAGE)) AS VARCHAR(128)) 
ELSE CAST( NULL AS VARCHAR(128)) 
END AS CHARACTER_SET_NAME, 
CASE 
WHEN D.SOURCETYPE IN ('CHARACTER', 'VARCHAR', 'LONG VARCHAR', 
'CLOB', 'DBCLOB', 'GRAPHIC', 
'VARGRAPHIC', 'LONG VARGRAPHIC') 
THEN CAST(CURRENT SERVER AS VARCHAR(128)) 
ELSE NULL 
END AS COLLATION_CATALOG, 
CASE 
WHEN D.SOURCETYPE IN ('CHARACTER', 'VARCHAR', 'LONG VARCHAR', 
'CLOB', 'DBCLOB', 'GRAPHIC', 
'VARGRAPHIC', 'LONG VARGRAPHIC') 
THEN CAST('SYSIBM' AS VARCHAR(128)) 
ELSE NULL 
END AS COLLATION_SCHEMA, 
CASE 
WHEN D.SOURCETYPE IN ('CHARACTER', 'VARCHAR', 'LONG VARCHAR', 
'CLOB', 'DBCLOB', 'GRAPHIC', 
'VARGRAPHIC', 'LONG VARGRAPHIC') 
THEN CAST('IBMDEFAULT' AS VARCHAR(128)) 
ELSE NULL 
END AS COLLATION_NAME, 
CASE 
WHEN D.SOURCETYPE = 'INTEGER'  THEN 10 
WHEN D.SOURCETYPE = 'BIGINT'   THEN 19 
WHEN D.SOURCETYPE = 'SMALLINT' THEN 5 
WHEN D.SOURCETYPE = 'REAL'     THEN 24 
WHEN D.SOURCETYPE = 'DOUBLE'   THEN 53 
WHEN D.SOURCETYPE = 'DECIMAL'  THEN D.LENGTH 
ELSE CAST(NULL AS INTEGER) 
END AS NUMERIC_PRECISION, 
CASE 
WHEN D.SOURCETYPE IN ('INTEGER', 'BIGINT', 'SMALLINT', 'DECIMAL') 
THEN 10 
WHEN D.SOURCETYPE IN('REAL', 'DOUBLE') 
THEN 2 
ELSE CAST(NULL AS INTEGER) 
END AS NUMERIC_PRECISION_RADIX, 
CASE 
WHEN D.SOURCETYPE ='DECIMAL' THEN  CAST(D.SCALE AS INTEGER) 
WHEN D.SOURCETYPE IN ('INTEGER', 'SMALLINT')  THEN 0 
ELSE CAST(NULL AS INTEGER) 
END AS NUMERIC_SCALE, 
CASE 
WHEN D.SOURCETYPE IN ('DATE','TIME') THEN 0 
WHEN D.SOURCETYPE = 'TIMESTAMP'      THEN CAST(D.SCALE AS INTEGER) 
ELSE CAST(NULL AS INTEGER) 
END AS DATETIME_PRECISION, 
CAST(NULL AS VARCHAR(128)) AS INTERVAL_TYPE, 
CAST(NULL AS INTEGER) AS INTERVAL_PRECISION, 
CASE 
WHEN D.METATYPE='T' 
THEN CAST(CONCAT('D',HEX(D.TYPEID)) AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END AS SOURCE_DTD_IDENTIFIER, 
CASE 
WHEN D.METATYPE='R' 
THEN CAST(CONCAT('D',HEX(D.TYPEID)) AS VARCHAR(128)) 
ELSE CAST(NULL AS VARCHAR(128)) 
END AS REF_DTD_IDENTIFIER 
FROM SYSIBM.SYSDATATYPES D 
WHERE D.METATYPE IN ('T', 'R')
;

-- View: SYSIBM.VIEWS
CREATE VIEW SYSIBM.VIEWS AS CREATE OR REPLACE VIEW SYSIBM.VIEWS 
( 
TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, VIEW_DEFINITION, 
CHECK_OPTION, IS_UPDATABLE 
) 
AS 
SELECT CAST(CURRENT SERVER AS VARCHAR(128)), V.CREATOR , V.NAME , V.TEXT, 
CASE V.CHECK 
WHEN 'N' THEN 'NONE' 
WHEN 'L' THEN 'LOCAL' 
WHEN 'C' THEN 'CASCADED' 
END , 
CASE V.READONLY 
WHEN 'Y' THEN 'NO' 
WHEN 'N' THEN 'YES' 
END 
FROM SYSIBM.SYSVIEWS V,SYSIBM.SYSTABLES T 
WHERE V.CREATOR=T.CREATOR AND V.NAME=T.NAME AND T.TYPE='V'
;

-- Schema: SYSIBMADM
CREATE SCHEMA SYSIBMADM;

-- View: SYSIBMADM.ADMINTABCOMPRESSINFO
CREATE VIEW SYSIBMADM.ADMINTABCOMPRESSINFO AS CREATE OR REPLACE VIEW SYSIBMADM.ADMINTABCOMPRESSINFO 
(TABSCHEMA, TABNAME, DBPARTITIONNUM, DATA_PARTITION_ID, 
COMPRESS_ATTR, DICT_BUILDER, DICT_BUILD_TIMESTAMP, 
COMPRESS_DICT_SIZE, EXPAND_DICT_SIZE, ROWS_SAMPLED, 
PAGES_SAVED_PERCENT, BYTES_SAVED_PERCENT, 
AVG_COMPRESS_REC_LENGTH, TENANT_ID, TENANT_NAME ) 
AS SELECT 
TABINFO.TABSCHEMA, TABINFO.TABNAME, TABINFO.DBPARTITIONNUM, 
TABINFO.DATA_PARTITION_ID, TABINFO.COMPRESS_ATTR, 
TABINFO.DICT_BUILDER, TABINFO.DICT_BUILD_TIMESTAMP, 
TABINFO.COMPRESS_DICT_SIZE, TABINFO.EXPAND_DICT_SIZE, 
TABINFO.ROWS_SAMPLED, TABINFO.PAGES_SAVED_PERCENT, 
TABINFO.BYTES_SAVED_PERCENT, TABINFO.AVG_COMPRESS_REC_LENGTH, 
TABINFO.TENANT_ID, TABINFO.TENANT_NAME 
FROM TABLE(SYSPROC.ADMIN_GET_TAB_COMPRESS_INFO( '', '','')) AS TABINFO 

;

-- View: SYSIBMADM.ADMINTABINFO
CREATE VIEW SYSIBMADM.ADMINTABINFO AS CREATE OR REPLACE VIEW SYSIBMADM.ADMINTABINFO 
(TABSCHEMA, TABNAME, TABTYPE, DBPARTITIONNUM, DATA_PARTITION_ID, 
AVAILABLE, DATA_OBJECT_L_SIZE, DATA_OBJECT_P_SIZE, 
INDEX_OBJECT_L_SIZE, INDEX_OBJECT_P_SIZE, LONG_OBJECT_L_SIZE, 
LONG_OBJECT_P_SIZE, LOB_OBJECT_L_SIZE, LOB_OBJECT_P_SIZE, 
XML_OBJECT_L_SIZE, XML_OBJECT_P_SIZE, INDEX_TYPE, REORG_PENDING, 
INPLACE_REORG_STATUS, LOAD_STATUS, READ_ACCESS_ONLY, NO_LOAD_RESTART, 
NUM_REORG_REC_ALTERS, INDEXES_REQUIRE_REBUILD, LARGE_RIDS, 
LARGE_SLOTS, DICTIONARY_SIZE, BLOCKS_PENDING_CLEANUP, 
STATSTYPE, XML_RECORD_TYPE, RECLAIMABLE_SPACE, 
XML_DICTIONARY_SIZE, AMT_STATUS, SPARSE_BLOCKS, 
STATS_ROWS_MODIFIED, RTS_ROWS_MODIFIED, 
STATS_DBPARTITION, COL_OBJECT_L_SIZE, COL_OBJECT_P_SIZE, 
STATSPROFTYPE, TENANT_ID, TENANT_NAME) 
AS SELECT 
TABINFO.TABSCHEMA, TABINFO.TABNAME, TABINFO.TABTYPE, 
TABINFO.DBPARTITIONNUM, TABINFO.DATA_PARTITION_ID, TABINFO.AVAILABLE, 
TABINFO.DATA_OBJECT_L_SIZE, TABINFO.DATA_OBJECT_P_SIZE, 
TABINFO.INDEX_OBJECT_L_SIZE, TABINFO.INDEX_OBJECT_P_SIZE, 
TABINFO.LONG_OBJECT_L_SIZE, TABINFO.LONG_OBJECT_P_SIZE, 
TABINFO.LOB_OBJECT_L_SIZE, TABINFO.LOB_OBJECT_P_SIZE, 
TABINFO.XML_OBJECT_L_SIZE, TABINFO.XML_OBJECT_P_SIZE, 
TABINFO.INDEX_TYPE, TABINFO.REORG_PENDING, TABINFO.INPLACE_REORG_STATUS, 
TABINFO.LOAD_STATUS, TABINFO.READ_ACCESS_ONLY, TABINFO.NO_LOAD_RESTART, 
TABINFO.NUM_REORG_REC_ALTERS, TABINFO.INDEXES_REQUIRE_REBUILD, TABINFO.LARGE_RIDS, 
TABINFO.LARGE_SLOTS, TABINFO.DICTIONARY_SIZE, TABINFO.BLOCKS_PENDING_CLEANUP, 
TABINFO.STATSTYPE, TABINFO.XML_RECORD_TYPE, TABINFO.RECLAIMABLE_SPACE, 
TABINFO.XML_DICTIONARY_SIZE, TABINFO.AMT_STATUS, TABINFO.SPARSE_BLOCKS, 
TABINFO.STATS_ROWS_MODIFIED, TABINFO.RTS_ROWS_MODIFIED, 
TABINFO.STATS_DBPARTITION, TABINFO.COL_OBJECT_L_SIZE, TABINFO.COL_OBJECT_P_SIZE, 
TABINFO.STATSPROFTYPE, TABINFO.TENANT_ID, TABINFO.TENANT_NAME 
FROM TABLE(SYSPROC.ADMIN_GET_TAB_INFO( '', '')) AS TABINFO 

;

-- View: SYSIBMADM.ADMINTEMPCOLUMNS
CREATE VIEW SYSIBMADM.ADMINTEMPCOLUMNS AS CREATE OR REPLACE VIEW SYSIBMADM.ADMINTEMPCOLUMNS 
(APPLICATION_HANDLE, 
APPLICATION_NAME, 
TABSCHEMA, 
TABNAME, 
COLNAME, 
COLNO, 
TYPESCHEMA, 
TYPENAME, 
LENGTH, 
SCALE, 
DEFAULT, 
NULLS, 
CODEPAGE, 
LOGGED, 
COMPACT, 
INLINE_LENGTH, 
IDENTITY, 
GENERATED) 
AS SELECT 
T.APPLICATION_HANDLE, 
T.APPLICATION_NAME, 
T.TABSCHEMA, 
T.TABNAME, 
T.COLNAME, 
T.COLNO, 
T.TYPESCHEMA, 
T.TYPENAME, 
T.LENGTH, 
T.SCALE, 
T.DEFAULT, 
T.NULLS, 
T.CODEPAGE, 
T.LOGGED, 
T.COMPACT, 
T.INLINE_LENGTH, 
T.IDENTITY, 
T.GENERATED 
FROM TABLE(SYSPROC.ADMIN_GET_TEMP_COLUMNS(CAST (NULL AS BIGINT), 
NULL, NULL)) T 

;

-- View: SYSIBMADM.ADMINTEMPTABLES
CREATE VIEW SYSIBMADM.ADMINTEMPTABLES AS CREATE OR REPLACE VIEW SYSIBMADM.ADMINTEMPTABLES 
(APPLICATION_HANDLE, 
APPLICATION_NAME, 
TABSCHEMA, 
TABNAME, 
INSTANTIATOR, 
INSTANTIATORTYPE, 
TEMPTABTYPE, 
INSTANTIATION_TIME, 
COLCOUNT, 
TAB_FILE_ID, 
TBSP_ID, 
PMAP_ID, 
PARTITION_MODE, 
CODEPAGE , 
ONCOMMIT , 
ONROLLBACK , 
LOGGED , 
TAB_ORGANIZATION) 
AS SELECT 
T.APPLICATION_HANDLE, 
T.APPLICATION_NAME, 
T.TABSCHEMA, 
T.TABNAME, 
T.INSTANTIATOR, 
T.INSTANTIATORTYPE, 
T.TEMPTABTYPE, 
T.INSTANTIATION_TIME, 
T.COLCOUNT, 
T.TAB_FILE_ID, 
T.TBSP_ID, 
T.PMAP_ID, 
T.PARTITION_MODE, 
T.CODEPAGE , 
T.ONCOMMIT , 
T.ONROLLBACK , 
T.LOGGED, 
T.TAB_ORGANIZATION 
FROM TABLE (SYSPROC.ADMIN_GET_TEMP_TABLES(CAST (NULL AS BIGINT), 
NULL, NULL)) T 

;

-- View: SYSIBMADM.APPLICATIONS
CREATE VIEW SYSIBMADM.APPLICATIONS AS CREATE OR REPLACE VIEW SYSIBMADM.APPLICATIONS 
( SNAPSHOT_TIMESTAMP, CLIENT_DB_ALIAS, DB_NAME, AGENT_ID, APPL_NAME, AUTHID, 
APPL_ID, APPL_STATUS, STATUS_CHANGE_TIME, SEQUENCE_NO, CLIENT_PRDID, CLIENT_PID, 
CLIENT_PLATFORM, CLIENT_PROTOCOL, CLIENT_NNAME,  COORD_NODE_NUM, COORD_AGENT_PID, 
NUM_ASSOC_AGENTS, TPMON_CLIENT_USERID, TPMON_CLIENT_WKSTN, TPMON_CLIENT_APP, 
TPMON_ACC_STR, DBPARTITIONNUM, MEMBER, COORD_MEMBER, COORD_DBPARTITIONNUM) 
AS SELECT 
SNAPSHOT_TIMESTAMP, CLIENT_DB_ALIAS, DB_NAME, AGENT_ID, APPL_NAME, PRIMARY_AUTH_ID, APPL_ID, 
APPL_STATUS, STATUS_CHANGE_TIME, SEQUENCE_NO, CLIENT_PRDID, CLIENT_PID, CLIENT_PLATFORM, 
CLIENT_PROTOCOL, CLIENT_NNAME,  COORD_NODE_NUM, COORD_AGENT_PID, NUM_ASSOC_AGENTS, 
TPMON_CLIENT_USERID, TPMON_CLIENT_WKSTN, TPMON_CLIENT_APP, TPMON_ACC_STR, DBPARTITIONNUM, MEMBER, COORD_MEMBER, COORD_DBPARTITIONNUM 
FROM SYSIBMADM.SNAPAPPL_INFO 

;

-- View: SYSIBMADM.APPL_PERFORMANCE
CREATE VIEW SYSIBMADM.APPL_PERFORMANCE AS CREATE OR REPLACE VIEW SYSIBMADM.APPL_PERFORMANCE 
( SNAPSHOT_TIMESTAMP, AUTHID, APPL_NAME, AGENT_ID, 
PERCENT_ROWS_SELECTED, DBPARTITIONNUM, MEMBER) 
AS SELECT 
AI.SNAPSHOT_TIMESTAMP, AI.PRIMARY_AUTH_ID, AI.APPL_NAME, AI.AGENT_ID, 
CASE WHEN AP.ROWS_READ > 0 AND AP.ROWS_SELECTED <= AP.ROWS_READ 
THEN DEC((FLOAT(AP.ROWS_SELECTED)/FLOAT(AP.ROWS_READ))*100,5,2) 
WHEN AP.ROWS_READ > 0 AND AP.ROWS_SELECTED > AP.ROWS_READ 
THEN 100.00 
ELSE NULL 
END, 
AI.DBPARTITIONNUM, 
AI.MEMBER 
FROM SYSIBMADM.SNAPAPPL_INFO AI, SYSIBMADM.SNAPAPPL AP 
WHERE AI.AGENT_ID = AP.AGENT_ID AND AI.MEMBER = AP.MEMBER 

;

-- View: SYSIBMADM.AUTHORIZATIONIDS
CREATE VIEW SYSIBMADM.AUTHORIZATIONIDS AS CREATE OR REPLACE VIEW SYSIBMADM.AUTHORIZATIONIDS 
( AUTHID, AUTHIDTYPE ) 
AS 
(SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.COLAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.DBAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.INDEXAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.LIBRARYAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.MODULEAUTH) 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.PASSTHRUAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.PACKAGEAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.ROLEAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.ROUTINEAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.SCHEMAAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.SEQUENCEAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.TABAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.TBSPACEAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.XSROBJECTAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.VARIABLEAUTH 
UNION 
SELECT GRANTEE, GRANTEETYPE FROM SYSCAT.WORKLOADAUTH 

;

-- View: SYSIBMADM.BP_HITRATIO
CREATE VIEW SYSIBMADM.BP_HITRATIO AS CREATE OR REPLACE VIEW SYSIBMADM.BP_HITRATIO 
( SNAPSHOT_TIMESTAMP, DB_NAME, BP_NAME, TOTAL_LOGICAL_READS, TOTAL_PHYSICAL_READS, 
TOTAL_HIT_RATIO_PERCENT, DATA_LOGICAL_READS, DATA_PHYSICAL_READS, DATA_HIT_RATIO_PERCENT, 
INDEX_LOGICAL_READS, INDEX_PHYSICAL_READS, INDEX_HIT_RATIO_PERCENT, 
XDA_LOGICAL_READS, XDA_PHYSICAL_READS, XDA_HIT_RATIO_PERCENT, DBPARTITIONNUM, MEMBER) 
AS 
WITH BP_DATA AS 
( SELECT SNAPSHOT_TIMESTAMP, DB_NAME, BP_NAME, 
POOL_DATA_L_READS + POOL_TEMP_DATA_L_READS AS TOTAL_DATA_LOGICAL_READS, 
POOL_INDEX_L_READS + POOL_TEMP_INDEX_L_READS AS TOTAL_INDEX_LOGICAL_READS, 
POOL_XDA_L_READS + POOL_TEMP_XDA_L_READS AS TOTAL_XDA_LOGICAL_READS, 
POOL_DATA_P_READS + POOL_TEMP_DATA_P_READS AS TOTAL_DATA_PHYSICAL_READS, 
POOL_INDEX_P_READS + POOL_TEMP_INDEX_P_READS AS TOTAL_INDEX_PHYSICAL_READS, 
POOL_XDA_P_READS + POOL_TEMP_XDA_P_READS AS TOTAL_XDA_PHYSICAL_READS, 
POOL_ASYNC_INDEX_READS, POOL_ASYNC_DATA_READS, POOL_ASYNC_XDA_READS, 
POOL_ASYNC_INDEX_READS + POOL_ASYNC_DATA_READS + POOL_ASYNC_XDA_READS AS TOTAL_ASYNC_READS, 
DBPARTITIONNUM, MEMBER 
FROM SYSIBMADM.SNAPBP) 
SELECT 
SNAPSHOT_TIMESTAMP, DB_NAME, BP_NAME, 
TOTAL_DATA_LOGICAL_READS + TOTAL_INDEX_LOGICAL_READS + TOTAL_XDA_LOGICAL_READS AS TOTAL_LOGICAL_READS, 
TOTAL_DATA_PHYSICAL_READS + TOTAL_INDEX_PHYSICAL_READS + TOTAL_XDA_PHYSICAL_READS AS TOTAL_PHYSICAL_READS, 
CASE WHEN (TOTAL_DATA_LOGICAL_READS + TOTAL_INDEX_LOGICAL_READS + TOTAL_XDA_LOGICAL_READS) > 0 
THEN DEC((1 - (FLOAT(TOTAL_DATA_PHYSICAL_READS + TOTAL_INDEX_PHYSICAL_READS + TOTAL_XDA_PHYSICAL_READS - TOTAL_ASYNC_READS) / FLOAT(TOTAL_DATA_LOGICAL_READS + TOTAL_INDEX_LOGICAL_READS + TOTAL_XDA_LOGICAL_READS))) * 100,5,2) 
ELSE NULL 
END AS TOTAL_HIT_RATIO, 
TOTAL_DATA_LOGICAL_READS, TOTAL_DATA_PHYSICAL_READS, 
CASE WHEN TOTAL_DATA_LOGICAL_READS > 0 
THEN DEC((1 - (FLOAT(TOTAL_DATA_PHYSICAL_READS - POOL_ASYNC_DATA_READS) / FLOAT(TOTAL_DATA_LOGICAL_READS))) * 100,5,2) 
ELSE NULL 
END AS DATA_HIT_RATIO, 
TOTAL_INDEX_LOGICAL_READS, TOTAL_INDEX_PHYSICAL_READS, 
CASE WHEN TOTAL_INDEX_LOGICAL_READS > 0 
THEN DEC((1 - (FLOAT(TOTAL_INDEX_PHYSICAL_READS - POOL_ASYNC_INDEX_READS) / FLOAT(TOTAL_INDEX_LOGICAL_READS))) * 100,5,2) 
ELSE NULL 
END AS INDEX_HIT_RATIO, 
TOTAL_XDA_LOGICAL_READS, TOTAL_XDA_PHYSICAL_READS, 
CASE WHEN TOTAL_XDA_LOGICAL_READS > 0 
THEN DEC((1 - (FLOAT(TOTAL_XDA_PHYSICAL_READS - POOL_ASYNC_XDA_READS) / FLOAT(TOTAL_XDA_LOGICAL_READS))) * 100,5,2) 
ELSE NULL 
END AS XDA_HIT_RATIO, 
DBPARTITIONNUM, 
MEMBER 
FROM BP_DATA 

;

-- View: SYSIBMADM.BP_READ_IO
CREATE VIEW SYSIBMADM.BP_READ_IO AS CREATE OR REPLACE VIEW SYSIBMADM.BP_READ_IO 
( SNAPSHOT_TIMESTAMP, BP_NAME, TOTAL_PHYSICAL_READS, AVERAGE_READ_TIME_MS, 
TOTAL_ASYNC_READS, AVERAGE_ASYNC_READ_TIME_MS, TOTAL_SYNC_READS, 
AVERAGE_SYNC_READ_TIME_MS, PERCENT_SYNC_READS, ASYNC_NOT_READ_PERCENT, 
DBPARTITIONNUM, MEMBER) 
AS 
WITH BP_DATA AS ( SELECT SNAPSHOT_TIMESTAMP, BP_NAME, 
POOL_DATA_P_READS + POOL_INDEX_P_READS + POOL_TEMP_DATA_P_READS + POOL_TEMP_INDEX_P_READS + POOL_XDA_P_READS + POOL_TEMP_XDA_P_READS AS TOTAL_READS, 
POOL_ASYNC_DATA_READS + POOL_ASYNC_INDEX_READS + POOL_ASYNC_XDA_READS AS TOTAL_ASYNC, 
UNREAD_PREFETCH_PAGES, POOL_READ_TIME, POOL_ASYNC_READ_TIME, DBPARTITIONNUM, MEMBER 
FROM SYSIBMADM.SNAPBP) 
SELECT 
SNAPSHOT_TIMESTAMP, BP_NAME, TOTAL_READS, 
CAST(CASE WHEN TOTAL_READS > 0 
THEN POOL_READ_TIME / TOTAL_READS 
ELSE NULL 
END AS BIGINT), 
TOTAL_ASYNC, 
CAST(CASE WHEN TOTAL_ASYNC > 0 
THEN POOL_ASYNC_READ_TIME / TOTAL_ASYNC 
ELSE NULL 
END AS BIGINT), 
TOTAL_READS - TOTAL_ASYNC, 
CAST(CASE WHEN (TOTAL_READS - TOTAL_ASYNC) > 0 
THEN (POOL_READ_TIME - POOL_ASYNC_READ_TIME) / (TOTAL_READS - TOTAL_ASYNC) 
ELSE NULL 
END AS BIGINT), 
CASE WHEN TOTAL_READS > 0 
THEN DEC(100 * FLOAT(TOTAL_READS - TOTAL_ASYNC) / FLOAT(TOTAL_READS), 5,2) 
ELSE NULL 
END, 
CASE WHEN TOTAL_READS > 0 
THEN DEC(100 * FLOAT(UNREAD_PREFETCH_PAGES) / FLOAT(TOTAL_READS), 5,2) 
ELSE NULL 
END, 
DBPARTITIONNUM, 
MEMBER 
FROM BP_DATA 

;

-- View: SYSIBMADM.BP_WRITE_IO
CREATE VIEW SYSIBMADM.BP_WRITE_IO AS CREATE OR REPLACE VIEW SYSIBMADM.BP_WRITE_IO 
( SNAPSHOT_TIMESTAMP, BP_NAME, TOTAL_WRITES, AVERAGE_WRITE_TIME_MS, 
TOTAL_ASYNC_WRITES, PERCENT_WRITES_ASYNC, AVERAGE_ASYNC_WRITE_TIME_MS, 
TOTAL_SYNC_WRITES, AVERAGE_SYNC_WRITE_TIME_MS, DBPARTITIONNUM, MEMBER) 
AS 
WITH BP_DATA AS ( SELECT SNAPSHOT_TIMESTAMP, BP_NAME, 
POOL_DATA_WRITES + POOL_INDEX_WRITES + POOL_XDA_WRITES AS TOTAL_WRITES, 
POOL_ASYNC_DATA_WRITES + POOL_ASYNC_INDEX_WRITES + POOL_ASYNC_XDA_WRITES AS TOTAL_ASYNC, 
POOL_WRITE_TIME, POOL_ASYNC_WRITE_TIME, DBPARTITIONNUM, MEMBER 
FROM SYSIBMADM.SNAPBP ) 
SELECT 
SNAPSHOT_TIMESTAMP, BP_NAME, TOTAL_WRITES, 
CAST(CASE WHEN TOTAL_WRITES > 0 
THEN POOL_WRITE_TIME / TOTAL_WRITES 
ELSE NULL 
END AS BIGINT), 
TOTAL_ASYNC, 
CAST(CASE WHEN TOTAL_WRITES > 0 
THEN ((TOTAL_ASYNC * 100) / TOTAL_WRITES) 
ELSE NULL 
END AS BIGINT), 
CAST(CASE WHEN TOTAL_ASYNC > 0 
THEN POOL_ASYNC_WRITE_TIME / TOTAL_ASYNC 
ELSE NULL 
END AS BIGINT), 
TOTAL_WRITES - TOTAL_ASYNC, 
CAST(CASE WHEN (TOTAL_WRITES - TOTAL_ASYNC) > 0 
THEN (POOL_WRITE_TIME - POOL_ASYNC_WRITE_TIME) / (TOTAL_WRITES - TOTAL_ASYNC) 
ELSE NULL 
END AS BIGINT), 
DBPARTITIONNUM, 
MEMBER 
FROM BP_DATA 

;

-- View: SYSIBMADM.CONTACTGROUPS
CREATE VIEW SYSIBMADM.CONTACTGROUPS AS CREATE OR REPLACE VIEW SYSIBMADM.CONTACTGROUPS 
(NAME, DESCRIPTION, MEMBERNAME, MEMBERTYPE) 
AS SELECT 
CONTACTGROUPS.NAME, CONTACTGROUPS.DESCRIPTION, 
CONTACTGROUPS.MEMBERNAME, CONTACTGROUPS.MEMBERTYPE 
FROM TABLE(SYSPROC.ADMIN_GET_CONTACTGROUPS()) AS CONTACTGROUPS 

;

-- View: SYSIBMADM.CONTACTS
CREATE VIEW SYSIBMADM.CONTACTS AS CREATE OR REPLACE VIEW SYSIBMADM.CONTACTS 
(NAME, TYPE, ADDRESS, MAX_PAGE_LENGTH, DESCRIPTION) 
AS SELECT 
CONTACTS.NAME, CONTACTS.TYPE, CONTACTS.ADDRESS, 
CONTACTS.MAX_PAGE_LENGTH, CONTACTS.DESCRIPTION 
FROM TABLE(SYSPROC.ADMIN_GET_CONTACTS()) AS CONTACTS 

;

-- View: SYSIBMADM.CONTAINER_UTILIZATION
CREATE VIEW SYSIBMADM.CONTAINER_UTILIZATION AS CREATE OR REPLACE VIEW SYSIBMADM.CONTAINER_UTILIZATION 
( SNAPSHOT_TIMESTAMP, TBSP_NAME, TBSP_ID, CONTAINER_NAME, CONTAINER_ID, 
CONTAINER_TYPE, TOTAL_PAGES, USABLE_PAGES, ACCESSIBLE, STRIPE_SET, FS_ID, 
FS_TOTAL_SIZE_KB, FS_USED_SIZE_KB, DBPARTITIONNUM) 
AS SELECT 
SNAPSHOT_TIMESTAMP, TBSP_NAME, TBSP_ID, CONTAINER_NAME, CONTAINER_ID, 
CONTAINER_TYPE, TOTAL_PAGES, USABLE_PAGES, ACCESSIBLE, STRIPE_SET, 
FS_ID, CAST(FS_TOTAL_SIZE / 1024 AS BIGINT), CAST(FS_USED_SIZE / 1024 AS BIGINT), 
DBPARTITIONNUM 
FROM SYSIBMADM.SNAPCONTAINER 

;

-- View: SYSIBMADM.DB2_CF
CREATE VIEW SYSIBMADM.DB2_CF AS CREATE OR REPLACE VIEW SYSIBMADM.DB2_CF 
(ID, CURRENT_HOST, STATE, ALERT) 
AS SELECT 
ID, CURRENT_HOST, STATE, ALERT 
FROM TABLE(SYSPROC.DB2_GET_INSTANCE_INFO( 
CAST( NULL AS INTEGER ), 
CAST( NULL AS VARCHAR(255) ), 
CAST( NULL AS VARCHAR(255) ), 
'CF', 
CAST( NULL AS INTEGER ) 
)) AS T 

;

-- View: SYSIBMADM.DB2_CLUSTER_HOST_STATE
CREATE VIEW SYSIBMADM.DB2_CLUSTER_HOST_STATE AS CREATE OR REPLACE VIEW SYSIBMADM.DB2_CLUSTER_HOST_STATE 
(HOSTNAME, STATE, INSTANCE_STOPPED, ALERT) 
AS SELECT 
HOSTNAME, STATE, INSTANCE_STOPPED, ALERT 
FROM TABLE(SYSPROC.DB2_GET_CLUSTER_HOST_STATE( 
CAST( NULL AS VARCHAR(255) ))) AS T 

;

-- View: SYSIBMADM.DB2_INSTANCE_ALERTS
CREATE VIEW SYSIBMADM.DB2_INSTANCE_ALERTS AS CREATE OR REPLACE VIEW SYSIBMADM.DB2_INSTANCE_ALERTS 
(MESSAGE, ACTION, IMPACT) 
AS SELECT 
MESSAGE, ACTION, IMPACT 
FROM TABLE(SYSPROC.DB2_GET_INSTANCE_ALERTS () ) 
AS T 

;

-- View: SYSIBMADM.DB2_MEMBER
CREATE VIEW SYSIBMADM.DB2_MEMBER AS CREATE OR REPLACE VIEW SYSIBMADM.DB2_MEMBER 
(ID, HOME_HOST, CURRENT_HOST, STATE, ALERT) 
AS SELECT 
ID, HOME_HOST, CURRENT_HOST, STATE, ALERT 
FROM TABLE(SYSPROC.DB2_GET_INSTANCE_INFO( 
CAST( NULL AS INTEGER ), 
CAST( NULL AS VARCHAR(255) ), 
CAST( NULL AS VARCHAR(255) ), 
'MEMBER', 
CAST( NULL AS INTEGER ) 
)) AS T 

;

-- View: SYSIBMADM.DBCFG
CREATE VIEW SYSIBMADM.DBCFG AS CREATE OR REPLACE VIEW SYSIBMADM.DBCFG 
(NAME, VALUE, VALUE_FLAGS, DEFERRED_VALUE, DEFERRED_VALUE_FLAGS, 
DATATYPE, DBPARTITIONNUM, MEMBER) 
AS SELECT 
CONFIG.NAME, CONFIG.VALUE, CONFIG.VALUE_FLAGS, CONFIG.DEFERRED_VALUE, 
CONFIG.DEFERRED_VALUE_FLAGS, CONFIG.DATATYPE, CONFIG.DBPARTITIONNUM, CONFIG.MEMBER 
FROM TABLE(SYSPROC.DB_GET_CFG(-2)) AS CONFIG 

;

-- View: SYSIBMADM.DBMCFG
CREATE VIEW SYSIBMADM.DBMCFG AS CREATE OR REPLACE VIEW SYSIBMADM.DBMCFG 
(NAME, VALUE, VALUE_FLAGS, DEFERRED_VALUE, DEFERRED_VALUE_FLAGS, 
DATATYPE) 
AS SELECT 
CONFIG.NAME, CONFIG.VALUE, CONFIG.VALUE_FLAGS, CONFIG.DEFERRED_VALUE, 
CONFIG.DEFERRED_VALUE_FLAGS, CONFIG.DATATYPE 
FROM TABLE(SYSPROC.DBM_GET_CFG()) AS CONFIG 

;

-- View: SYSIBMADM.DBPATHS
CREATE VIEW SYSIBMADM.DBPATHS AS CREATE OR REPLACE VIEW SYSIBMADM.DBPATHS 
( DBPARTITIONNUM, TYPE, PATH ) 
AS SELECT 
DBPARTITIONNUM, TYPE, PATH 
FROM TABLE(SYSPROC.ADMIN_LIST_DB_PATHS()) AS T 

;

-- View: SYSIBMADM.DB_HISTORY
CREATE VIEW SYSIBMADM.DB_HISTORY AS CREATE OR REPLACE VIEW SYSIBMADM.DB_HISTORY 
(dbpartitionnum, EID, start_time, seqnum, end_time, num_log_elems, 
firstlog, lastlog, backup_id, tabschema, tabname, 
comment, cmd_text, num_tbsps, tbspnames, operation, 
operationtype, objecttype, location, devicetype, entry_status, 
sqlcaid, sqlcabc, sqlcode, sqlerrml, sqlerrmc, sqlerrp, 
sqlerrd1, sqlerrd2, sqlerrd3, sqlerrd4, sqlerrd5, sqlerrd6, 
sqlwarn, sqlstate ) 
AS SELECT 
dbpartitionnum, EID, start_time, seqnum, end_time, num_log_elems, 
firstlog, lastlog, backup_id, tabschema, tabname, 
comment, cmd_text, num_tbsps, tbspnames, operation, 
operationtype, objecttype, location, devicetype, entry_status, 
sqlcaid, sqlcabc, sqlcode, sqlerrml, sqlerrmc, sqlerrp, 
sqlerrd1, sqlerrd2, sqlerrd3, sqlerrd4, sqlerrd5, sqlerrd6, 
sqlwarn, sqlstate 
FROM TABLE(SYSPROC.ADMIN_LIST_HIST()) as t 

;

-- View: SYSIBMADM.ENV_CF_SYS_RESOURCES
CREATE VIEW SYSIBMADM.ENV_CF_SYS_RESOURCES AS CREATE OR REPLACE VIEW SYSIBMADM.ENV_CF_SYS_RESOURCES 
(name, value, datatype, unit, id) 
AS SELECT 
name, value, datatype, unit, id 
FROM TABLE(SYSPROC.ENV_GET_CF_SYS_RESOURCES()) as t 

;

-- View: SYSIBMADM.ENV_FEATURE_INFO
CREATE VIEW SYSIBMADM.ENV_FEATURE_INFO AS CREATE OR REPLACE VIEW SYSIBMADM.ENV_FEATURE_INFO 
(feature_name, feature_fullname, license_installed, product_name, 
feature_use_status) 
AS SELECT 
feature_name, feature_fullname, license_installed, product_name, 
feature_use_status 
FROM TABLE(SYSPROC.ENV_GET_FEATURE_INFO()) as t 

;

-- View: SYSIBMADM.ENV_INST_INFO
CREATE VIEW SYSIBMADM.ENV_INST_INFO AS CREATE OR REPLACE VIEW SYSIBMADM.ENV_INST_INFO 
(inst_name, is_inst_partitionable, num_dbpartitions, inst_ptr_size, 
release_num, service_level, bld_level, ptf, fixpack_num, num_members) 
AS SELECT 
inst_name, is_inst_partitionable, num_dbpartitions, inst_ptr_size, 
release_num, service_level, bld_level, ptf, fixpack_num, num_members 
FROM TABLE(SYSPROC.ENV_GET_INST_INFO()) as t 

;

-- View: SYSIBMADM.ENV_PROD_INFO
CREATE VIEW SYSIBMADM.ENV_PROD_INFO AS CREATE OR REPLACE VIEW SYSIBMADM.ENV_PROD_INFO 
(installed_prod, installed_prod_fullname, license_installed, 
prod_release, license_type ) 
AS SELECT 
installed_prod, installed_prod_fullname, license_installed, 
prod_release, license_type 
FROM TABLE(SYSPROC.ENV_GET_PROD_INFO()) as t 

;

-- View: SYSIBMADM.ENV_SYS_INFO
CREATE VIEW SYSIBMADM.ENV_SYS_INFO AS CREATE OR REPLACE VIEW SYSIBMADM.ENV_SYS_INFO 
(os_name, os_version, os_release, host_name, total_cpus, 
configured_cpus, total_memory, os_full_version, os_kernel_version, 
os_arch_type ) 
AS SELECT 
os_name, os_version, os_release, host_name, cpu_total as total_cpus, 
cpu_configured as configured_cpus, memory_total as total_memory, 
os_full_version, os_kernel_version, os_arch_type 
FROM TABLE(SYSPROC.ENV_GET_SYSTEM_RESOURCES()) as t where MEMBER = CURRENT MEMBER 

;

-- View: SYSIBMADM.ENV_SYS_RESOURCES
CREATE VIEW SYSIBMADM.ENV_SYS_RESOURCES AS CREATE OR REPLACE VIEW SYSIBMADM.ENV_SYS_RESOURCES 
(name, value, datatype, unit, dbpartitionnum) 
AS SELECT 
name, value, datatype, unit, dbpartitionnum 
FROM TABLE(SYSPROC.ENV_GET_SYS_RESOURCES()) as t 

;

-- View: SYSIBMADM.INGEST_USER_CONNECTIONS
CREATE VIEW SYSIBMADM.INGEST_USER_CONNECTIONS AS CREATE OR REPLACE VIEW SYSIBMADM.INGEST_USER_CONNECTIONS 
AS SELECT 
APPLICATION_ID, APPLICATION_NAME, CLIENT_ACCTNG, MEMBER 
FROM TABLE(MON_GET_CONNECTION(NULL, -2)) AS T 
WHERE T.SESSION_AUTH_ID = SESSION_USER AND 
T.MEMBER = T.COORD_MEMBER AND 
T.APPLICATION_NAME = 'DB2_INGEST' 

;

-- View: SYSIBMADM.LOCKS_HELD
CREATE VIEW SYSIBMADM.LOCKS_HELD AS CREATE OR REPLACE VIEW SYSIBMADM.LOCKS_HELD 
( SNAPSHOT_TIMESTAMP, DB_NAME, AGENT_ID, APPL_NAME, AUTHID, 
TBSP_NAME, TABSCHEMA, TABNAME, TAB_FILE_ID, LOCK_OBJECT_TYPE, 
LOCK_NAME, LOCK_MODE, LOCK_STATUS,  LOCK_ESCALATION, DBPARTITIONNUM, MEMBER) 
AS SELECT 
S.SNAPSHOT_TIMESTAMP, A.DB_NAME, S.AGENT_ID, A.APPL_NAME, 
A.PRIMARY_AUTH_ID, S.TBSP_NAME, S.TABSCHEMA, S.TABNAME, S.TAB_FILE_ID, 
S.LOCK_OBJECT_TYPE, S.LOCK_NAME, S.LOCK_MODE, S.LOCK_STATUS, 
S.LOCK_ESCALATION, S.DBPARTITIONNUM, S.MEMBER 
FROM SYSIBMADM.SNAPLOCK AS S, SYSIBMADM.SNAPAPPL_INFO AS A 
WHERE S.AGENT_ID = A.AGENT_ID AND S.MEMBER = A.MEMBER 

;

-- View: SYSIBMADM.LOCKWAITS
CREATE VIEW SYSIBMADM.LOCKWAITS AS CREATE OR REPLACE VIEW SYSIBMADM.LOCKWAITS 
( SNAPSHOT_TIMESTAMP, DB_NAME, AGENT_ID, APPL_NAME, AUTHID, 
TBSP_NAME, TABSCHEMA, TABNAME, SUBSECTION_NUMBER, LOCK_OBJECT_TYPE, 
LOCK_WAIT_START_TIME, LOCK_NAME, LOCK_MODE, LOCK_MODE_REQUESTED, 
AGENT_ID_HOLDING_LK, APPL_ID_HOLDING_LK, LOCK_ESCALATION, DBPARTITIONNUM, MEMBER ) 
AS SELECT 
S.SNAPSHOT_TIMESTAMP, A.DB_NAME, S.AGENT_ID, A.APPL_NAME, A.PRIMARY_AUTH_ID, 
S.TBSP_NAME, S.TABSCHEMA, S.TABNAME, S.SUBSECTION_NUMBER, S.LOCK_OBJECT_TYPE, 
S.LOCK_WAIT_START_TIME, S.LOCK_NAME, S.LOCK_MODE, S.LOCK_MODE_REQUESTED, 
S.AGENT_ID_HOLDING_LK, S.APPL_ID_HOLDING_LK, S.LOCK_ESCALATION, 
S.DBPARTITIONNUM, S. MEMBER 
FROM SYSIBMADM.SNAPLOCKWAIT AS S, SYSIBMADM.SNAPAPPL_INFO AS A 
WHERE S.AGENT_ID = A.AGENT_ID AND S.MEMBER = A.MEMBER 

;

-- View: SYSIBMADM.LOG_UTILIZATION
CREATE VIEW SYSIBMADM.LOG_UTILIZATION AS CREATE OR REPLACE VIEW SYSIBMADM.LOG_UTILIZATION 
( DB_NAME, LOG_UTILIZATION_PERCENT, TOTAL_LOG_USED_KB, TOTAL_LOG_AVAILABLE_KB, 
TOTAL_LOG_USED_TOP_KB, DBPARTITIONNUM, MEMBER) 
AS SELECT 
DB_NAME, 
CASE 
WHEN TOTAL_LOG_AVAILABLE = -1 THEN DEC(-1,5,2) 
WHEN (TOTAL_LOG_AVAILABLE + TOTAL_LOG_USED) = 0 THEN 0 
ELSE DEC(100 * (FLOAT(TOTAL_LOG_USED)/FLOAT(TOTAL_LOG_USED + TOTAL_LOG_AVAILABLE)), 5,2) 
END, 
TOTAL_LOG_USED / 1024, 
CASE (TOTAL_LOG_AVAILABLE) 
WHEN -1 THEN -1 
ELSE TOTAL_LOG_AVAILABLE / 1024 
END, 
TOT_LOG_USED_TOP / 1024, DBPARTITIONNUM, MEMBER 
FROM SYSIBMADM.SNAPDB 

;

-- View: SYSIBMADM.LONG_RUNNING_SQL
CREATE VIEW SYSIBMADM.LONG_RUNNING_SQL AS CREATE OR REPLACE VIEW SYSIBMADM.LONG_RUNNING_SQL 
( SNAPSHOT_TIMESTAMP, ELAPSED_TIME_MIN, AGENT_ID, APPL_NAME, 
APPL_STATUS, AUTHID, INBOUND_COMM_ADDRESS, STMT_TEXT, DBPARTITIONNUM, MEMBER) 
AS SELECT 
AI.SNAPSHOT_TIMESTAMP, 
CASE WHEN ST.STMT_STOP IS NULL 
THEN ( (JULIAN_DAY(CURRENT TIMESTAMP) - JULIAN_DAY(ST.STMT_START)) * 24 
+ (HOUR(CURRENT TIMESTAMP)       - HOUR(ST.STMT_START))) * 60 
+ (MINUTE(CURRENT TIMESTAMP)     - MINUTE(ST.STMT_START)) 
ELSE INT(ST.STMT_ELAPSED_TIME_S/60) 
END, 
AI.AGENT_ID, AI.APPL_NAME, AI.APPL_STATUS, AI.PRIMARY_AUTH_ID, 
AP.INBOUND_COMM_ADDRESS, ST.STMT_TEXT, AI.DBPARTITIONNUM, AI.MEMBER 
FROM SYSIBMADM.SNAPSTMT ST, SYSIBMADM.SNAPAPPL_INFO AI, SYSIBMADM.SNAPAPPL AP 
WHERE ST.AGENT_ID = AI.AGENT_ID AND AI.AGENT_ID = AP.AGENT_ID 
AND ST.MEMBER = AI.MEMBER AND AI.MEMBER = AP.MEMBER 

;

-- View: SYSIBMADM.MON_BP_UTILIZATION
CREATE VIEW SYSIBMADM.MON_BP_UTILIZATION AS CREATE OR REPLACE VIEW SYSIBMADM.MON_BP_UTILIZATION 
(BP_NAME, MEMBER, 
DATA_PHYSICAL_READS, DATA_HIT_RATIO_PERCENT, 
INDEX_PHYSICAL_READS, INDEX_HIT_RATIO_PERCENT, 
XDA_PHYSICAL_READS, XDA_HIT_RATIO_PERCENT, 
COL_PHYSICAL_READS, COL_HIT_RATIO_PERCENT, 
TOTAL_PHYSICAL_READS, AVG_PHYSICAL_READ_TIME, 
PREFETCH_RATIO_PERCENT, ASYNC_NOT_READ_PERCENT, 
TOTAL_WRITES, AVG_WRITE_TIME, SYNC_WRITES_PERCENT, 
GBP_DATA_HIT_RATIO_PERCENT, GBP_INDEX_HIT_RATIO_PERCENT, 
GBP_XDA_HIT_RATIO_PERCENT, GBP_COL_HIT_RATIO_PERCENT, 
CACHING_TIER_DATA_HIT_RATIO_PERCENT, CACHING_TIER_INDEX_HIT_RATIO_PERCENT, 
CACHING_TIER_XDA_HIT_RATIO_PERCENT, CACHING_TIER_COL_HIT_RATIO_PERCENT, 
AVG_SYNC_READ_TIME, AVG_ASYNC_READ_TIME, 
AVG_SYNC_WRITE_TIME, AVG_ASYNC_WRITE_TIME) 
AS 
WITH BP_DATA AS 
(SELECT BP_NAME, MEMBER, 
(POOL_DATA_L_READS + POOL_TEMP_DATA_L_READS) AS DATA_LOGICAL_READS, 
(POOL_INDEX_L_READS + POOL_TEMP_INDEX_L_READS) AS INDEX_LOGICAL_READS, 
(POOL_XDA_L_READS + POOL_TEMP_XDA_L_READS) AS XDA_LOGICAL_READS, 
(POOL_COL_L_READS + POOL_TEMP_COL_L_READS) AS COL_LOGICAL_READS, 
(POOL_DATA_P_READS + POOL_TEMP_DATA_P_READS) AS DATA_PHYSICAL_READS, 
(POOL_INDEX_P_READS + POOL_TEMP_INDEX_P_READS) AS INDEX_PHYSICAL_READS, 
(POOL_XDA_P_READS + POOL_TEMP_XDA_P_READS) AS XDA_PHYSICAL_READS, 
(POOL_COL_P_READS + POOL_TEMP_COL_P_READS) AS COL_PHYSICAL_READS, 
(POOL_DATA_P_READS + POOL_TEMP_DATA_P_READS + POOL_INDEX_P_READS + 
POOL_TEMP_INDEX_P_READS + POOL_XDA_P_READS + POOL_TEMP_XDA_P_READS + 
POOL_COL_P_READS + POOL_TEMP_COL_P_READS) AS TOTAL_PHYSICAL_READS, 
(POOL_ASYNC_DATA_READS + POOL_ASYNC_INDEX_READS + POOL_ASYNC_XDA_READS + POOL_ASYNC_COL_READS) 
AS TOTAL_ASYNC_READS, 
POOL_READ_TIME, UNREAD_PREFETCH_PAGES, 
(POOL_DATA_WRITES + POOL_INDEX_WRITES + POOL_XDA_WRITES + POOL_COL_WRITES) AS TOTAL_WRITES, 
(POOL_ASYNC_DATA_WRITES + POOL_ASYNC_INDEX_WRITES + POOL_ASYNC_XDA_WRITES + POOL_ASYNC_COL_WRITES) 
AS TOTAL_ASYNC_WRITES, 
POOL_WRITE_TIME, 
(POOL_DATA_LBP_PAGES_FOUND - POOL_ASYNC_DATA_LBP_PAGES_FOUND) 
AS TOTAL_LBP_DATA_PAGES_FOUND, 
(POOL_INDEX_LBP_PAGES_FOUND - POOL_ASYNC_INDEX_LBP_PAGES_FOUND) 
AS TOTAL_LBP_INDEX_PAGES_FOUND, 
(POOL_XDA_LBP_PAGES_FOUND - POOL_ASYNC_XDA_LBP_PAGES_FOUND) 
AS TOTAL_LBP_XDA_PAGES_FOUND, 
(POOL_COL_LBP_PAGES_FOUND - POOL_ASYNC_COL_LBP_PAGES_FOUND) 
AS TOTAL_LBP_COL_PAGES_FOUND, 
POOL_DATA_GBP_P_READS, POOL_INDEX_GBP_P_READS, POOL_XDA_GBP_P_READS, POOL_COL_GBP_P_READS, 
POOL_DATA_GBP_L_READS, POOL_INDEX_GBP_L_READS, POOL_XDA_GBP_L_READS, POOL_COL_GBP_L_READS, 
(POOL_DATA_CACHING_TIER_L_READS - POOL_ASYNC_DATA_CACHING_TIER_READS) 
AS CACHING_TIER_DATA_L_READS, 
(POOL_DATA_CACHING_TIER_PAGES_FOUND - POOL_ASYNC_DATA_CACHING_TIER_PAGES_FOUND) 
AS CACHING_TIER_DATA_PAGES_FOUND, 
(POOL_INDEX_CACHING_TIER_L_READS - POOL_ASYNC_INDEX_CACHING_TIER_READS) 
AS CACHING_TIER_INDEX_L_READS, 
(POOL_INDEX_CACHING_TIER_PAGES_FOUND - POOL_ASYNC_INDEX_CACHING_TIER_PAGES_FOUND) 
AS CACHING_TIER_INDEX_PAGES_FOUND, 
(POOL_XDA_CACHING_TIER_L_READS - POOL_ASYNC_XDA_CACHING_TIER_READS) 
AS CACHING_TIER_XDA_L_READS, 
(POOL_XDA_CACHING_TIER_PAGES_FOUND - POOL_ASYNC_XDA_CACHING_TIER_PAGES_FOUND) 
AS CACHING_TIER_XDA_PAGES_FOUND, 
(POOL_COL_CACHING_TIER_L_READS - POOL_ASYNC_COL_CACHING_TIER_READS) 
AS CACHING_TIER_COL_L_READS, 
(POOL_COL_CACHING_TIER_PAGES_FOUND - POOL_ASYNC_COL_CACHING_TIER_PAGES_FOUND) 
AS CACHING_TIER_COL_PAGES_FOUND, 
POOL_ASYNC_READ_TIME, 
POOL_ASYNC_WRITE_TIME 
FROM TABLE(MON_GET_BUFFERPOOL(NULL, -2))) 
SELECT BP_NAME, MEMBER, 
DATA_PHYSICAL_READS, 
CASE WHEN DATA_LOGICAL_READS > 0 
THEN DEC((FLOAT(TOTAL_LBP_DATA_PAGES_FOUND) / FLOAT(DATA_LOGICAL_READS)) 
* 100, 5, 2) 
ELSE NULL 
END AS DATA_HIT_RATIO_PERCENT, 
INDEX_PHYSICAL_READS, 
CASE WHEN INDEX_LOGICAL_READS > 0 
THEN DEC((FLOAT(TOTAL_LBP_INDEX_PAGES_FOUND) / FLOAT(INDEX_LOGICAL_READS)) 
* 100, 5, 2) 
ELSE NULL 
END AS INDEX_HIT_RATIO_PERCENT, 
XDA_PHYSICAL_READS, 
CASE WHEN XDA_LOGICAL_READS > 0 
THEN DEC((FLOAT(TOTAL_LBP_XDA_PAGES_FOUND) / FLOAT(XDA_LOGICAL_READS)) 
* 100, 5, 2) 
ELSE NULL 
END AS XDA_HIT_RATIO_PERCENT, 
COL_PHYSICAL_READS, 
CASE WHEN COL_LOGICAL_READS > 0 
THEN DEC((FLOAT(TOTAL_LBP_COL_PAGES_FOUND) / FLOAT(COL_LOGICAL_READS)) 
* 100, 5, 2) 
ELSE NULL 
END AS COL_HIT_RATIO_PERCENT, 
TOTAL_PHYSICAL_READS, 
CASE WHEN TOTAL_PHYSICAL_READS > 0 
THEN POOL_READ_TIME / TOTAL_PHYSICAL_READS 
ELSE NULL 
END AS AVG_PHYSICAL_READ_TIME, 
CASE WHEN TOTAL_PHYSICAL_READS > 0 
THEN DEC(100 * FLOAT(TOTAL_ASYNC_READS) / FLOAT(TOTAL_PHYSICAL_READS), 5, 2) 
ELSE NULL 
END AS PREFETCH_RATIO_PERCENT, 
CASE WHEN TOTAL_ASYNC_READS > 0 
THEN DEC(100 * FLOAT(UNREAD_PREFETCH_PAGES) / FLOAT(TOTAL_ASYNC_READS), 5, 2) 
ELSE NULL 
END AS ASYNC_NOT_READ_PERCENT, 
TOTAL_WRITES, 
CASE WHEN TOTAL_WRITES > 0 
THEN POOL_WRITE_TIME / TOTAL_WRITES 
ELSE NULL 
END AS AVG_WRITE_TIME, 
CASE WHEN TOTAL_WRITES > 0 
THEN DEC((FLOAT(TOTAL_WRITES - TOTAL_ASYNC_WRITES) / FLOAT(TOTAL_WRITES)) 
* 100, 5, 2) 
ELSE NULL 
END AS SYNC_WRITES_PERCENT, 
CASE 
WHEN POOL_DATA_GBP_L_READS IS NULL THEN NULL 
WHEN POOL_DATA_GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(POOL_DATA_GBP_P_READS) / FLOAT(POOL_DATA_GBP_L_READS))) 
* 100, 5, 2) 
END AS GBP_DATA_HIT_RATIO_PERCENT, 
CASE 
WHEN POOL_INDEX_GBP_L_READS IS NULL THEN NULL 
WHEN POOL_INDEX_GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(POOL_INDEX_GBP_P_READS) / FLOAT(POOL_INDEX_GBP_L_READS))) 
* 100, 5, 2) 
END AS GBP_INDEX_HIT_RATIO_PERCENT, 
CASE 
WHEN POOL_XDA_GBP_L_READS IS NULL THEN NULL 
WHEN POOL_XDA_GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(POOL_XDA_GBP_P_READS) / FLOAT(POOL_XDA_GBP_L_READS))) 
* 100, 5, 2) 
END AS GBP_XDA_HIT_RATIO_PERCENT, 
CASE 
WHEN POOL_COL_GBP_L_READS IS NULL THEN NULL 
WHEN POOL_COL_GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(POOL_COL_GBP_P_READS) / FLOAT(POOL_COL_GBP_L_READS))) 
* 100, 5, 2) 
END AS GBP_COL_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_DATA_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_DATA_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_DATA_PAGES_FOUND) / FLOAT(CACHING_TIER_DATA_L_READS)) 
* 100, 5, 2) 
END AS CACHING_TIER_DATA_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_INDEX_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_INDEX_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_INDEX_PAGES_FOUND) / FLOAT(CACHING_TIER_INDEX_L_READS)) 
* 100, 5, 2) 
END AS CACHING_TIER_INDEX_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_XDA_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_XDA_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_XDA_PAGES_FOUND) / FLOAT(CACHING_TIER_XDA_L_READS)) 
* 100, 5, 2) 
END AS CACHING_TIER_XDA_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_COL_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_COL_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_COL_PAGES_FOUND) / FLOAT(CACHING_TIER_COL_L_READS)) 
* 100, 5, 2) 
END AS CACHING_TIER_COL_HIT_RATIO_PERCENT, 
CASE WHEN (TOTAL_PHYSICAL_READS - TOTAL_ASYNC_READS) > 0 
THEN (POOL_READ_TIME - POOL_ASYNC_READ_TIME) /  (TOTAL_PHYSICAL_READS - TOTAL_ASYNC_READS) 
ELSE NULL 
END AS AVG_SYNC_READ_TIME, 
CASE WHEN TOTAL_ASYNC_READS > 0 
THEN POOL_ASYNC_READ_TIME / TOTAL_ASYNC_READS 
ELSE NULL 
END AS AVG_ASYNC_READ_TIME, 
CASE WHEN (TOTAL_WRITES - TOTAL_ASYNC_WRITES) > 0 
THEN (POOL_WRITE_TIME - POOL_ASYNC_WRITE_TIME) / (TOTAL_WRITES - TOTAL_ASYNC_WRITES) 
ELSE NULL 
END AS AVG_SYNC_WRITE_TIME, 
CASE WHEN TOTAL_ASYNC_WRITES > 0 
THEN POOL_ASYNC_WRITE_TIME / TOTAL_ASYNC_WRITES 
ELSE NULL 
END AS AVG_ASYNC_WRITE_TIME 
FROM BP_DATA 

;

-- View: SYSIBMADM.MON_CONNECTION_SUMMARY
CREATE VIEW SYSIBMADM.MON_CONNECTION_SUMMARY AS CREATE OR REPLACE VIEW SYSIBMADM.MON_CONNECTION_SUMMARY 
(APPLICATION_HANDLE, APPLICATION_NAME, APPLICATION_ID, SESSION_AUTH_ID, 
TOTAL_APP_COMMITS, TOTAL_APP_ROLLBACKS, ACT_COMPLETED_TOTAL, 
APP_RQSTS_COMPLETED_TOTAL, AVG_RQST_CPU_TIME, ROUTINE_TIME_RQST_PERCENT, 
RQST_WAIT_TIME_PERCENT, ACT_WAIT_TIME_PERCENT, 
IO_WAIT_TIME_PERCENT, LOCK_WAIT_TIME_PERCENT, 
AGENT_WAIT_TIME_PERCENT, NETWORK_WAIT_TIME_PERCENT, 
SECTION_PROC_TIME_PERCENT, SECTION_SORT_PROC_TIME_PERCENT, 
COMPILE_PROC_TIME_PERCENT, TRANSACT_END_PROC_TIME_PERCENT, 
UTILS_PROC_TIME_PERCENT, 
AVG_LOCK_WAITS_PER_ACT, AVG_LOCK_TIMEOUTS_PER_ACT, 
AVG_DEADLOCKS_PER_ACT, AVG_LOCK_ESCALS_PER_ACT, 
ROWS_READ_PER_ROWS_RETURNED, TOTAL_BP_HIT_RATIO_PERCENT, 
TOTAL_GBP_HIT_RATIO_PERCENT, 
TOTAL_CACHING_TIER_HIT_RATIO_PERCENT, 
CF_WAIT_TIME_PERCENT, 
RECLAIM_WAIT_TIME_PERCENT, 
SPACEMAPPAGE_RECLAIM_WAIT_TIME_PERCENT) 
AS 
WITH METRICS AS 
(SELECT APPLICATION_HANDLE, 
SUM(TOTAL_APP_COMMITS) AS TOTAL_APP_COMMITS, 
SUM(TOTAL_APP_ROLLBACKS) AS TOTAL_APP_ROLLBACKS, 
SUM(ACT_COMPLETED_TOTAL) AS ACT_COMPLETED_TOTAL, 
SUM(ACT_COMPLETED_TOTAL + ACT_ABORTED_TOTAL) AS ACT_TOTAL, 
SUM(APP_RQSTS_COMPLETED_TOTAL) AS APP_RQSTS_COMPLETED_TOTAL, 
SUM(TOTAL_CPU_TIME) AS TOTAL_CPU_TIME, 
SUM(ROWS_READ) AS ROWS_READ, 
SUM(ROWS_RETURNED) AS ROWS_RETURNED, 
SUM(TOTAL_WAIT_TIME) AS TOTAL_WAIT_TIME, 
SUM(TOTAL_RQST_TIME) AS TOTAL_RQST_TIME, 
SUM(TOTAL_ACT_WAIT_TIME) AS TOTAL_ACT_WAIT_TIME, 
SUM(TOTAL_ACT_TIME) AS TOTAL_ACT_TIME, 
SUM(POOL_READ_TIME + POOL_WRITE_TIME + DIRECT_READ_TIME + DIRECT_WRITE_TIME) 
AS IO_WAIT_TIME, 
SUM(LOCK_WAIT_TIME) AS LOCK_WAIT_TIME, 
SUM(AGENT_WAIT_TIME) AS AGENT_WAIT_TIME, 
SUM(LOCK_WAITS) AS LOCK_WAITS, 
SUM(LOCK_TIMEOUTS) AS LOCK_TIMEOUTS, 
SUM(DEADLOCKS) AS DEADLOCKS, 
SUM(LOCK_ESCALS) AS LOCK_ESCALS, 
SUM(TCPIP_SEND_WAIT_TIME + TCPIP_RECV_WAIT_TIME + IPC_SEND_WAIT_TIME 
+ IPC_RECV_WAIT_TIME) AS NETWORK_WAIT_TIME, 
SUM(TOTAL_RQST_TIME - TOTAL_WAIT_TIME) AS PROC_TIME, 
SUM(TOTAL_SECTION_PROC_TIME) AS SECTION_PROC_TIME, 
SUM(TOTAL_SECTION_SORT_PROC_TIME) AS SECTION_SORT_PROC_TIME, 
SUM(TOTAL_COMPILE_PROC_TIME + TOTAL_IMPLICIT_COMPILE_PROC_TIME) 
AS COMPILE_PROC_TIME, 
SUM(TOTAL_COMMIT_PROC_TIME + TOTAL_ROLLBACK_PROC_TIME) 
AS TRANSACT_END_PROC_TIME, 
SUM(TOTAL_RUNSTATS_PROC_TIME + TOTAL_REORG_PROC_TIME + TOTAL_LOAD_PROC_TIME) 
AS UTILS_PROC_TIME, 
SUM(POOL_DATA_L_READS + POOL_TEMP_DATA_L_READS + POOL_INDEX_L_READS 
+ POOL_TEMP_INDEX_L_READS + POOL_XDA_L_READS + POOL_TEMP_XDA_L_READS 
+ POOL_COL_L_READS + POOL_TEMP_COL_L_READS) 
AS L_READS, 
SUM(POOL_DATA_LBP_PAGES_FOUND + POOL_INDEX_LBP_PAGES_FOUND + POOL_XDA_LBP_PAGES_FOUND 
+ POOL_COL_LBP_PAGES_FOUND) 
AS BP_PAGES_FOUND, 
SUM(TOTAL_ROUTINE_TIME) AS TOTAL_ROUTINE_TIME, 
SUM(POOL_DATA_GBP_L_READS + POOL_INDEX_GBP_L_READS + POOL_XDA_GBP_L_READS 
+ POOL_COL_GBP_L_READS) AS GBP_L_READS, 
SUM(POOL_DATA_GBP_P_READS + POOL_INDEX_GBP_P_READS + POOL_XDA_GBP_P_READS 
+ POOL_COL_GBP_P_READS) AS GBP_P_READS, 
SUM(POOL_DATA_CACHING_TIER_L_READS + POOL_INDEX_CACHING_TIER_L_READS + POOL_XDA_CACHING_TIER_L_READS 
+ POOL_COL_CACHING_TIER_L_READS) AS CACHING_TIER_L_READS, 
SUM(POOL_DATA_CACHING_TIER_PAGES_FOUND + POOL_INDEX_CACHING_TIER_PAGES_FOUND + POOL_XDA_CACHING_TIER_PAGES_FOUND 
+ POOL_COL_CACHING_TIER_PAGES_FOUND) AS CACHING_TIER_PAGES_FOUND, 
SUM(CF_WAIT_TIME) AS CF_WAIT_TIME, 
SUM(RECLAIM_WAIT_TIME) AS RECLAIM_WAIT_TIME, 
SUM(SPACEMAPPAGE_RECLAIM_WAIT_TIME) AS SPACEMAPPAGE_RECLAIM_WAIT_TIME 
FROM TABLE(MON_GET_CONNECTION(NULL, -2)) 
GROUP BY APPLICATION_HANDLE) 
SELECT C.APPLICATION_HANDLE, C.APPLICATION_NAME, C.APPLICATION_ID, C.SESSION_AUTH_ID, 
M.TOTAL_APP_COMMITS, M.TOTAL_APP_ROLLBACKS, 
M.ACT_COMPLETED_TOTAL, M.APP_RQSTS_COMPLETED_TOTAL, 
CASE WHEN M.APP_RQSTS_COMPLETED_TOTAL > 0 
THEN (M.TOTAL_CPU_TIME / M.APP_RQSTS_COMPLETED_TOTAL) 
ELSE NULL 
END AS AVG_RQST_CPU_TIME, 
CASE WHEN M.TOTAL_RQST_TIME > 0 
THEN DEC(FLOAT(M.TOTAL_ROUTINE_TIME) / FLOAT(M.TOTAL_RQST_TIME) * 100, 5, 2) 
ELSE NULL 
END AS ROUTINE_TIME_RQST_PERCENT, 
CASE WHEN M.TOTAL_RQST_TIME > 0 
THEN DEC(FLOAT(M.TOTAL_WAIT_TIME) / FLOAT(M.TOTAL_RQST_TIME) * 100, 5, 2) 
ELSE NULL 
END AS RQST_WAIT_TIME_PERCENT, 
CASE WHEN M.TOTAL_ACT_TIME > 0 
THEN DEC(FLOAT(M.TOTAL_ACT_WAIT_TIME) / FLOAT(M.TOTAL_ACT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS ACT_WAIT_TIME_PERCENT, 
CASE WHEN M.TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(M.IO_WAIT_TIME) / FLOAT(M.TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS IO_WAIT_TIME_PERCENT, 
CASE WHEN M.TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(M.LOCK_WAIT_TIME) / FLOAT(M.TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS LOCK_WAIT_TIME_PERCENT, 
CASE WHEN M.TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(M.AGENT_WAIT_TIME) / FLOAT(M.TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS AGENT_WAIT_TIME_PERCENT, 
CASE WHEN M.TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(M.NETWORK_WAIT_TIME) / FLOAT(M.TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS NETWORK_WAIT_TIME_PERCENT, 
CASE WHEN M.PROC_TIME > 0 
THEN DEC(FLOAT(M.SECTION_PROC_TIME) / FLOAT(M.PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SECTION_PROC_TIME_PERCENT, 
CASE WHEN M.PROC_TIME > 0 
THEN DEC(FLOAT(M.SECTION_SORT_PROC_TIME) / FLOAT(M.PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SECTION_SORT_PROC_TIME_PERCENT, 
CASE WHEN M.PROC_TIME > 0 
THEN DEC(FLOAT(M.COMPILE_PROC_TIME) / FLOAT(M.PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS COMPILE_PROC_TIME_PERCENT, 
CASE WHEN M.PROC_TIME > 0 
THEN DEC(FLOAT(M.TRANSACT_END_PROC_TIME) / FLOAT(M.PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS TRANSACT_END_PROC_TIME_PERCENT, 
CASE WHEN M.PROC_TIME > 0 
THEN DEC(FLOAT(M.UTILS_PROC_TIME) / FLOAT(M.PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS UTILS_PROC_TIME_PERCENT, 
CASE WHEN M.ACT_TOTAL > 0 
THEN M.LOCK_WAITS / M.ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_WAITS_PER_ACT, 
CASE WHEN M.ACT_TOTAL > 0 
THEN M.LOCK_TIMEOUTS / M.ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_TIMEOUTS_PER_ACT, 
CASE WHEN M.ACT_TOTAL > 0 
THEN M.DEADLOCKS / M.ACT_TOTAL 
ELSE NULL 
END AS AVG_DEADLOCKS_PER_ACT, 
CASE WHEN M.ACT_TOTAL > 0 
THEN M.LOCK_ESCALS / M.ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_ESCALS_PER_ACT, 
CASE WHEN M.ROWS_RETURNED > 0 
THEN M.ROWS_READ / M.ROWS_RETURNED 
ELSE NULL 
END AS ROWS_READ_PER_ROWS_RETURNED, 
CASE WHEN M.L_READS > 0 
THEN DEC((FLOAT(M.BP_PAGES_FOUND) / FLOAT(M.L_READS)) * 100, 5, 2) 
ELSE NULL 
END AS TOTAL_BP_HIT_RATIO_PERCENT, 
CASE 
WHEN M.GBP_L_READS IS NULL THEN NULL 
WHEN M.GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(M.GBP_P_READS) / FLOAT(M.GBP_L_READS))) * 100, 5, 2) 
END AS TOTAL_GBP_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_PAGES_FOUND) / FLOAT(CACHING_TIER_L_READS)) * 100, 5, 2) 
END AS TOTAL_CACHING_TIER_HIT_RATIO_PERCENT, 
CASE WHEN M.TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(M.CF_WAIT_TIME) / FLOAT(M.TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS CF_WAIT_TIME_PERCENT, 
CASE WHEN M.TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(M.RECLAIM_WAIT_TIME) / FLOAT(M.TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS RECLAIM_WAIT_TIME_PERCENT, 
CASE WHEN M.TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(M.SPACEMAPPAGE_RECLAIM_WAIT_TIME) / FLOAT(M.TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SPACEMAPPAGE_RECLAIM_WAIT_TIME_PERCENT 
FROM TABLE(MON_GET_CONNECTION(NULL, -2)) AS C 
JOIN METRICS AS M 
ON C.APPLICATION_HANDLE = M.APPLICATION_HANDLE 
WHERE C.MEMBER = C.COORD_MEMBER 

;

-- View: SYSIBMADM.MON_CURRENT_SQL
CREATE VIEW SYSIBMADM.MON_CURRENT_SQL AS CREATE OR REPLACE VIEW SYSIBMADM.MON_CURRENT_SQL 
(COORD_MEMBER, APPLICATION_HANDLE, APPLICATION_NAME, 
SESSION_AUTH_ID, CLIENT_APPLNAME, ELAPSED_TIME_SEC, 
ACTIVITY_STATE, ACTIVITY_TYPE, TOTAL_CPU_TIME, 
ROWS_READ, ROWS_RETURNED, QUERY_COST_ESTIMATE, 
DIRECT_READS, DIRECT_WRITES, 
APPLICATION_ID, UOW_ID, ACTIVITY_ID, 
STMT_TEXT) 
AS 
WITH WLM_METRICS AS 
(SELECT APPLICATION_HANDLE, 
UOW_ID, 
ACTIVITY_ID, 
MIN(COORD_MEMBER) AS COORD_MEMBER, 
SUM(TOTAL_CPU_TIME) AS TOTAL_CPU_TIME, 
SUM(ROWS_READ) AS ROWS_READ, 
SUM(ROWS_RETURNED) AS ROWS_RETURNED, 
SUM(DIRECT_READS) AS DIRECT_READS, 
SUM(DIRECT_WRITES) AS DIRECT_WRITES 
FROM TABLE(MON_GET_ACTIVITY(NULL, -2)) 
GROUP BY APPLICATION_HANDLE, UOW_ID, ACTIVITY_ID ) 
SELECT M.COORD_MEMBER AS COORD_MEMBER, 
W.APPLICATION_HANDLE AS APPLICATION_HANDLE, 
C.APPLICATION_NAME AS APPLICATION_NAME, 
C.SESSION_AUTH_ID AS SESSION_AUTH_ID, 
C.CLIENT_APPLNAME AS CLIENT_APPLNAME, 
((  (JULIAN_DAY(CURRENT TIMESTAMP) - JULIAN_DAY(W.LOCAL_START_TIME)) * 24 
+ (HOUR(CURRENT TIMESTAMP)       - HOUR(W.LOCAL_START_TIME))) * 60 
+ (MINUTE(CURRENT TIMESTAMP)     - MINUTE(W.LOCAL_START_TIME))) * 60 
+ (SECOND(CURRENT TIMESTAMP)     - SECOND(W.LOCAL_START_TIME)) 
AS ELAPSED_TIME_SEC, 
W.ACTIVITY_STATE as ACTIVITY_STATE, 
W.ACTIVITY_TYPE as ACTIVITY_TYPE, 
M.TOTAL_CPU_TIME AS TOTAL_CPU_TIME, 
M.ROWS_READ AS ROWS_READ, 
M.ROWS_RETURNED AS ROWS_RETURNED, 
W.QUERY_COST_ESTIMATE AS QUERY_COST_ESTIMATE, 
M.DIRECT_READS AS DIRECT_READS, 
M.DIRECT_WRITES AS DIRECT_WRITES, 
C.APPLICATION_ID AS APPLICATION_ID, 
M.UOW_ID AS UOW_ID, 
M.ACTIVITY_ID AS ACTIVITY_ID, 
W.STMT_TEXT AS STMT_TEXT 
FROM WLM_METRICS AS M 
JOIN TABLE(MON_GET_ACTIVITY(NULL, -2)) AS W 
ON W.APPLICATION_HANDLE = M.APPLICATION_HANDLE 
AND W.MEMBER = M.COORD_MEMBER 
AND W.UOW_ID = M.UOW_ID 
AND W.ACTIVITY_ID = M.ACTIVITY_ID 
JOIN TABLE(MON_GET_CONNECTION(NULL, -2)) AS C 
ON C.APPLICATION_HANDLE = M.APPLICATION_HANDLE 
AND C.MEMBER = M.COORD_MEMBER 

;

-- View: SYSIBMADM.MON_CURRENT_UOW
CREATE VIEW SYSIBMADM.MON_CURRENT_UOW AS CREATE OR REPLACE VIEW SYSIBMADM.MON_CURRENT_UOW 
(COORD_MEMBER, UOW_ID, APPLICATION_HANDLE, 
APPLICATION_NAME, SESSION_AUTH_ID, CLIENT_APPLNAME, 
ELAPSED_TIME_SEC, WORKLOAD_OCCURRENCE_STATE, TOTAL_CPU_TIME, 
TOTAL_ROWS_MODIFIED, TOTAL_ROWS_READ, TOTAL_ROWS_RETURNED) 
AS 
WITH UOW_METRICS AS 
(SELECT APPLICATION_HANDLE, 
MIN(COORD_MEMBER) AS COORD_MEMBER, 
SUM(TOTAL_CPU_TIME) AS TOTAL_CPU_TIME, 
SUM(ROWS_MODIFIED) AS TOTAL_ROWS_MODIFIED, 
SUM(ROWS_READ) AS TOTAL_ROWS_READ, 
SUM(ROWS_RETURNED) AS TOTAL_ROWS_RETURNED 
FROM TABLE(MON_GET_UNIT_OF_WORK(NULL, -2)) 
GROUP BY APPLICATION_HANDLE) 
SELECT M.COORD_MEMBER AS COORD_MEMBER, 
U.UOW_ID AS UOW_ID, 
M.APPLICATION_HANDLE AS APPLICATION_HANDLE, 
C.APPLICATION_NAME AS APPLICATION_NAME, 
U.SESSION_AUTH_ID AS SESSION_AUTH_ID, 
U.CLIENT_APPLNAME AS CLIENT_APPLNAME, 
CASE WHEN U.UOW_STOP_TIME IS NULL 
THEN ((  (JULIAN_DAY(CURRENT TIMESTAMP) - JULIAN_DAY(U.UOW_START_TIME)) * 24 
+ (HOUR(CURRENT TIMESTAMP)       - HOUR(U.UOW_START_TIME))) * 60 
+ (MINUTE(CURRENT TIMESTAMP)     - MINUTE(U.UOW_START_TIME))) * 60 
+ (SECOND(CURRENT TIMESTAMP)     - SECOND(U.UOW_START_TIME)) 
ELSE NULL 
END AS ELAPSED_TIME_SEC, 
U.WORKLOAD_OCCURRENCE_STATE as WORKLOAD_OCCURRENCE_STATE, 
M.TOTAL_CPU_TIME AS TOTAL_CPU_TIME, 
M.TOTAL_ROWS_MODIFIED AS TOTAL_ROWS_MODIFIED, 
M.TOTAL_ROWS_READ AS TOTAL_ROWS_READ, 
M.TOTAL_ROWS_RETURNED AS TOTAL_ROWS_RETURNED 
FROM UOW_METRICS AS M 
JOIN TABLE(MON_GET_UNIT_OF_WORK(NULL, -2)) AS U 
ON U.APPLICATION_HANDLE = M.APPLICATION_HANDLE 
AND U.MEMBER = M.COORD_MEMBER 
JOIN TABLE(MON_GET_CONNECTION(NULL, -2)) AS C 
ON C.APPLICATION_HANDLE = M.APPLICATION_HANDLE 
AND C.MEMBER = M.COORD_MEMBER 

;

-- View: SYSIBMADM.MON_DB_SUMMARY
CREATE VIEW SYSIBMADM.MON_DB_SUMMARY AS CREATE OR REPLACE VIEW SYSIBMADM.MON_DB_SUMMARY 
(TOTAL_APP_COMMITS, TOTAL_APP_ROLLBACKS, ACT_COMPLETED_TOTAL, 
APP_RQSTS_COMPLETED_TOTAL, AVG_RQST_CPU_TIME, ROUTINE_TIME_RQST_PERCENT, 
RQST_WAIT_TIME_PERCENT, ACT_WAIT_TIME_PERCENT, 
IO_WAIT_TIME_PERCENT, LOCK_WAIT_TIME_PERCENT, 
AGENT_WAIT_TIME_PERCENT, NETWORK_WAIT_TIME_PERCENT, 
SECTION_PROC_TIME_PERCENT, SECTION_SORT_PROC_TIME_PERCENT, 
COMPILE_PROC_TIME_PERCENT, TRANSACT_END_PROC_TIME_PERCENT, 
UTILS_PROC_TIME_PERCENT, 
AVG_LOCK_WAITS_PER_ACT, AVG_LOCK_TIMEOUTS_PER_ACT, 
AVG_DEADLOCKS_PER_ACT, AVG_LOCK_ESCALS_PER_ACT, 
ROWS_READ_PER_ROWS_RETURNED, TOTAL_BP_HIT_RATIO_PERCENT, 
TOTAL_GBP_HIT_RATIO_PERCENT, 
TOTAL_CACHING_TIER_HIT_RATIO_PERCENT, 
CF_WAIT_TIME_PERCENT, 
RECLAIM_WAIT_TIME_PERCENT, 
SPACEMAPPAGE_RECLAIM_WAIT_TIME_PERCENT) 
AS 
WITH METRICS AS 
(SELECT SUM(TOTAL_APP_COMMITS) AS TOTAL_APP_COMMITS, 
SUM(TOTAL_APP_ROLLBACKS) AS TOTAL_APP_ROLLBACKS, 
SUM(ACT_COMPLETED_TOTAL) AS ACT_COMPLETED_TOTAL, 
SUM(ACT_COMPLETED_TOTAL + ACT_ABORTED_TOTAL) AS ACT_TOTAL, 
SUM(APP_RQSTS_COMPLETED_TOTAL) AS APP_RQSTS_COMPLETED_TOTAL, 
SUM(TOTAL_CPU_TIME) AS TOTAL_CPU_TIME, 
SUM(ROWS_READ) AS ROWS_READ, 
SUM(ROWS_RETURNED) AS ROWS_RETURNED, 
SUM(TOTAL_WAIT_TIME) AS TOTAL_WAIT_TIME, 
SUM(TOTAL_RQST_TIME) AS TOTAL_RQST_TIME, 
SUM(TOTAL_ACT_WAIT_TIME) AS TOTAL_ACT_WAIT_TIME, 
SUM(TOTAL_ACT_TIME) AS TOTAL_ACT_TIME, 
SUM(POOL_READ_TIME + POOL_WRITE_TIME + DIRECT_READ_TIME + DIRECT_WRITE_TIME - POOL_ASYNC_READ_TIME - POOL_ASYNC_WRITE_TIME) 
AS IO_WAIT_TIME, 
SUM(LOCK_WAIT_TIME) AS LOCK_WAIT_TIME, 
SUM(AGENT_WAIT_TIME) AS AGENT_WAIT_TIME, 
SUM(LOCK_WAITS) AS LOCK_WAITS, 
SUM(LOCK_TIMEOUTS) AS LOCK_TIMEOUTS, 
SUM(DEADLOCKS) AS DEADLOCKS, 
SUM(LOCK_ESCALS) AS LOCK_ESCALS, 
SUM(TCPIP_SEND_WAIT_TIME + TCPIP_RECV_WAIT_TIME + IPC_SEND_WAIT_TIME 
+ IPC_RECV_WAIT_TIME) AS NETWORK_WAIT_TIME, 
SUM(TOTAL_RQST_TIME - TOTAL_WAIT_TIME) AS PROC_TIME, 
SUM(TOTAL_SECTION_PROC_TIME) AS SECTION_PROC_TIME, 
SUM(TOTAL_SECTION_SORT_PROC_TIME) AS SECTION_SORT_PROC_TIME, 
SUM(TOTAL_COMPILE_PROC_TIME + TOTAL_IMPLICIT_COMPILE_PROC_TIME) 
AS COMPILE_PROC_TIME, 
SUM(TOTAL_COMMIT_PROC_TIME + TOTAL_ROLLBACK_PROC_TIME) 
AS TRANSACT_END_PROC_TIME, 
SUM(TOTAL_RUNSTATS_PROC_TIME + TOTAL_REORG_PROC_TIME + TOTAL_LOAD_PROC_TIME) 
AS UTILS_PROC_TIME, 
SUM(POOL_DATA_L_READS + POOL_TEMP_DATA_L_READS + POOL_INDEX_L_READS 
+ POOL_TEMP_INDEX_L_READS + POOL_XDA_L_READS + POOL_TEMP_XDA_L_READS 
+ POOL_COL_L_READS + POOL_TEMP_COL_L_READS) 
AS L_READS, 
SUM(POOL_DATA_LBP_PAGES_FOUND + POOL_INDEX_LBP_PAGES_FOUND + POOL_XDA_LBP_PAGES_FOUND 
+ POOL_COL_LBP_PAGES_FOUND - POOL_ASYNC_DATA_LBP_PAGES_FOUND 
- POOL_ASYNC_INDEX_LBP_PAGES_FOUND - POOL_ASYNC_XDA_LBP_PAGES_FOUND 
- POOL_ASYNC_COL_LBP_PAGES_FOUND ) 
AS BP_PAGES_FOUND, 
SUM(TOTAL_ROUTINE_TIME) AS TOTAL_ROUTINE_TIME, 
SUM(POOL_DATA_GBP_L_READS + POOL_INDEX_GBP_L_READS + POOL_XDA_GBP_L_READS 
+ POOL_COL_GBP_L_READS) AS GBP_L_READS, 
SUM(POOL_DATA_GBP_P_READS + POOL_INDEX_GBP_P_READS + POOL_XDA_GBP_P_READS 
+ POOL_COL_GBP_P_READS) AS GBP_P_READS, 
SUM(POOL_DATA_CACHING_TIER_L_READS + POOL_INDEX_CACHING_TIER_L_READS + POOL_XDA_CACHING_TIER_L_READS 
+ POOL_COL_CACHING_TIER_L_READS) AS CACHING_TIER_L_READS, 
SUM(POOL_DATA_CACHING_TIER_PAGES_FOUND + POOL_INDEX_CACHING_TIER_PAGES_FOUND + POOL_XDA_CACHING_TIER_PAGES_FOUND 
+ POOL_COL_CACHING_TIER_PAGES_FOUND) AS CACHING_TIER_PAGES_FOUND, 
SUM(CF_WAIT_TIME) AS CF_WAIT_TIME, 
SUM(RECLAIM_WAIT_TIME) AS RECLAIM_WAIT_TIME, 
SUM(SPACEMAPPAGE_RECLAIM_WAIT_TIME) AS SPACEMAPPAGE_RECLAIM_WAIT_TIME 
FROM TABLE(MON_GET_DATABASE(-2))) 
SELECT TOTAL_APP_COMMITS, TOTAL_APP_ROLLBACKS, 
ACT_COMPLETED_TOTAL, APP_RQSTS_COMPLETED_TOTAL, 
CASE WHEN APP_RQSTS_COMPLETED_TOTAL > 0 
THEN (TOTAL_CPU_TIME / APP_RQSTS_COMPLETED_TOTAL) 
ELSE NULL 
END AS AVG_RQST_CPU_TIME, 
CASE WHEN TOTAL_RQST_TIME > 0 
THEN DEC(FLOAT(TOTAL_ROUTINE_TIME) / FLOAT(TOTAL_RQST_TIME) * 100, 5, 2) 
ELSE NULL 
END AS ROUTINE_TIME_RQST_PERCENT, 
CASE WHEN TOTAL_RQST_TIME > 0 
THEN DEC(FLOAT(TOTAL_WAIT_TIME) / FLOAT(TOTAL_RQST_TIME) * 100, 5, 2) 
ELSE NULL 
END AS RQST_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_ACT_TIME > 0 
THEN DEC(FLOAT(TOTAL_ACT_WAIT_TIME) / FLOAT(TOTAL_ACT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS ACT_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(IO_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS IO_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(LOCK_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS LOCK_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(AGENT_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS AGENT_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(NETWORK_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS NETWORK_WAIT_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(SECTION_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SECTION_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(SECTION_SORT_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SECTION_SORT_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(COMPILE_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS COMPILE_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(TRANSACT_END_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS TRANSACT_END_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(UTILS_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS UTILS_PROC_TIME_PERCENT, 
CASE WHEN ACT_TOTAL > 0 
THEN LOCK_WAITS / ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_WAITS_PER_ACT, 
CASE WHEN ACT_TOTAL > 0 
THEN LOCK_TIMEOUTS / ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_TIMEOUTS_PER_ACT, 
CASE WHEN ACT_TOTAL > 0 
THEN DEADLOCKS / ACT_TOTAL 
ELSE NULL 
END AS AVG_DEADLOCKS_PER_ACT, 
CASE WHEN ACT_TOTAL > 0 
THEN LOCK_ESCALS / ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_ESCALS_PER_ACT, 
CASE WHEN ROWS_RETURNED > 0 
THEN ROWS_READ / ROWS_RETURNED 
ELSE NULL 
END AS ROWS_READ_PER_ROWS_RETURNED, 
CASE WHEN L_READS > 0 
THEN DEC((FLOAT(BP_PAGES_FOUND) / FLOAT(L_READS)) * 100, 5, 2) 
ELSE NULL 
END AS TOTAL_BP_HIT_RATIO_PERCENT, 
CASE 
WHEN GBP_L_READS IS NULL THEN NULL 
WHEN GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(GBP_P_READS) / FLOAT(GBP_L_READS))) * 100, 5, 2) 
END AS TOTAL_GBP_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_PAGES_FOUND) / FLOAT(CACHING_TIER_L_READS)) * 100, 5, 2) 
END AS TOTAL_CACHING_TIER_HIT_RATIO_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(CF_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS CF_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(RECLAIM_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS RECLAIM_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(SPACEMAPPAGE_RECLAIM_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SPACEMAPPAGE_RECLAIM_WAIT_TIME_PERCENT 
FROM METRICS 

;

-- View: SYSIBMADM.MON_LOCKWAITS
CREATE VIEW SYSIBMADM.MON_LOCKWAITS AS CREATE OR REPLACE VIEW SYSIBMADM.MON_LOCKWAITS 
( LOCK_NAME, LOCK_OBJECT_TYPE, LOCK_WAIT_ELAPSED_TIME, TABSCHEMA, TABNAME, 
DATA_PARTITION_ID, LOCK_MODE, LOCK_CURRENT_MODE, LOCK_MODE_REQUESTED, 
REQ_APPLICATION_HANDLE, REQ_AGENT_TID, REQ_MEMBER, REQ_APPLICATION_NAME, 
REQ_USERID, REQ_STMT_TEXT, HLD_APPLICATION_HANDLE, HLD_MEMBER, 
HLD_APPLICATION_NAME, HLD_USERID, HLD_CURRENT_STMT_TEXT ) 
AS 
SELECT L.LOCK_NAME, L.LOCK_OBJECT_TYPE, 
((  (JULIAN_DAY(CURRENT TIMESTAMP) - JULIAN_DAY(L.LOCK_WAIT_START_TIME)) * 24 
+ (HOUR(CURRENT TIMESTAMP)       - HOUR(L.LOCK_WAIT_START_TIME))) * 60 
+ (MINUTE(CURRENT TIMESTAMP)     - MINUTE(L.LOCK_WAIT_START_TIME))) * 60 
+ (SECOND(CURRENT TIMESTAMP)     - SECOND(L.LOCK_WAIT_START_TIME)) 
AS LOCK_WAIT_ELAPSED_TIME, 
CASE 
WHEN L.TBSP_ID > 0 THEN T.TABSCHEMA 
ELSE S.TABSCHEMA 
END, 
CASE 
WHEN L.TBSP_ID > 0 THEN T.TABNAME 
ELSE S.TABNAME 
END, 
CASE 
WHEN L.TBSP_ID > 0 THEN T.DATA_PARTITION_ID 
ELSE -1 
END, 
L.LOCK_MODE, L.LOCK_CURRENT_MODE, L.LOCK_MODE_REQUESTED, 
L.REQ_APPLICATION_HANDLE, L.REQ_AGENT_TID, 
L.REQ_MEMBER, REQ_C.APPLICATION_NAME AS REQ_APPLICATION_NAME, 
REQ_C.SESSION_AUTH_ID AS REQ_USERID, 
REQ_P.STMT_TEXT AS REQ_STMT_TEXT, 
L.HLD_APPLICATION_HANDLE, L.HLD_MEMBER, 
HLD_D.APPLICATION_NAME AS HLD_APPLICATION_NAME, 
HLD_D.SESSION_AUTH_ID AS HLD_USERID, 
HLD_P.STMT_TEXT AS HLD_CURRENT_STMT_TEXT 
FROM TABLE( MON_GET_APPL_LOCKWAIT( NULL, -2 )) AS L 
LEFT OUTER JOIN 
TABLE( MON_GET_CONNECTION( L.HLD_APPLICATION_HANDLE, L.HLD_MEMBER ) 
) AS HLD_D 
ON L.HLD_MEMBER             = HLD_D.MEMBER AND 
L.HLD_APPLICATION_HANDLE = HLD_D.APPLICATION_HANDLE AND 
L.HLD_APPLICATION_HANDLE IS NOT NULL 
LEFT OUTER JOIN 
TABLE( WLM_GET_SERVICE_CLASS_AGENTS( NULL, NULL, 
L.HLD_APPLICATION_HANDLE, 
HLD_D.COORD_MEMBER ) 
) AS HLD_A 
ON L.HLD_APPLICATION_HANDLE = HLD_A.APPLICATION_HANDLE AND 
HLD_A.AGENT_TYPE         = 'COORDINATOR' AND 
L.HLD_APPLICATION_HANDLE IS NOT NULL 
LEFT OUTER JOIN 
TABLE( WLM_GET_WORKLOAD_OCCURRENCE_ACTIVITIES( L.HLD_APPLICATION_HANDLE, 
HLD_D.COORD_MEMBER ) 
) AS HLD_ACT 
ON HLD_A.APPLICATION_HANDLE = HLD_ACT.APPLICATION_HANDLE AND 
HLD_A.UOW_ID             = HLD_ACT.UOW_ID AND 
HLD_A.ACTIVITY_ID        = HLD_ACT.ACTIVITY_ID AND 
HLD_A.APPLICATION_HANDLE IS NOT NULL 
LEFT OUTER JOIN 
TABLE( MON_GET_PKG_CACHE_STMT( NULL, HLD_ACT.EXECUTABLE_ID, 
NULL, HLD_D.COORD_MEMBER ) 
) AS HLD_P 
ON HLD_D.COORD_MEMBER     = HLD_P.MEMBER AND 
HLD_ACT.EXECUTABLE_ID  = HLD_P.EXECUTABLE_ID AND 
HLD_ACT.EXECUTABLE_ID IS NOT NULL AND 
L.HLD_APPLICATION_HANDLE IS NOT NULL 
LEFT OUTER JOIN 
TABLE( MON_GET_TABLE( NULL, NULL, L.HLD_MEMBER )) AS T 
ON L.TBSP_ID     = T.TBSP_ID AND 
L.TAB_FILE_ID = T.TAB_FILE_ID AND 
L.HLD_MEMBER  = T.MEMBER AND 
L.TBSP_ID IS NOT NULL AND 
L.TAB_FILE_ID IS NOT NULL 
LEFT OUTER JOIN 
SYSCAT.TABLES  AS S 
ON L.TBSP_ID     = S.TBSPACEID AND 
L.TAB_FILE_ID = S.TABLEID AND 
L.TBSP_ID IS NOT NULL AND 
L.TAB_FILE_ID IS NOT NULL 
LEFT OUTER JOIN 
TABLE( MON_GET_CONNECTION( L.REQ_APPLICATION_HANDLE, L.REQ_MEMBER ) 
) AS REQ_C 
ON L.REQ_MEMBER = REQ_C.MEMBER AND 
L.REQ_APPLICATION_HANDLE = REQ_C.APPLICATION_HANDLE AND 
L.REQ_APPLICATION_HANDLE IS NOT NULL 
LEFT OUTER JOIN 
TABLE( MON_GET_PKG_CACHE_STMT( NULL, L.REQ_EXECUTABLE_ID, 
NULL, REQ_C.COORD_MEMBER ) 
) AS REQ_P 
ON REQ_C.COORD_MEMBER = REQ_P.MEMBER AND 
L.REQ_EXECUTABLE_ID = REQ_P.EXECUTABLE_ID AND 
L.REQ_EXECUTABLE_ID IS NOT NULL 

;

-- View: SYSIBMADM.MON_PKG_CACHE_SUMMARY
CREATE VIEW SYSIBMADM.MON_PKG_CACHE_SUMMARY AS CREATE OR REPLACE VIEW SYSIBMADM.MON_PKG_CACHE_SUMMARY 
(SECTION_TYPE, EXECUTABLE_ID, NUM_COORD_EXEC, NUM_COORD_EXEC_WITH_METRICS, 
TOTAL_STMT_EXEC_TIME, AVG_STMT_EXEC_TIME, TOTAL_CPU_TIME, AVG_CPU_TIME, 
TOTAL_LOCK_WAIT_TIME, AVG_LOCK_WAIT_TIME, TOTAL_IO_WAIT_TIME, AVG_IO_WAIT_TIME, 
PREP_TIME, ROWS_READ_PER_ROWS_RETURNED, 
AVG_ACT_WAIT_TIME, 
AVG_LOCK_ESCALS, 
AVG_RECLAIM_WAIT_TIME, 
AVG_SPACEMAPPAGE_RECLAIM_WAIT_TIME, 
STMT_TEXT) 
AS 
WITH EXEC_METRICS AS 
(SELECT EXECUTABLE_ID, 
MIN(MEMBER) AS MIN_MEMBER, 
SUM(NUM_COORD_EXEC) AS NUM_COORD_EXEC, 
SUM(NUM_COORD_EXEC_WITH_METRICS) AS NUM_COORD_EXEC_WITH_METRICS, 
SUM(STMT_EXEC_TIME) AS TOTAL_STMT_EXEC_TIME, 
SUM(TOTAL_CPU_TIME) AS TOTAL_CPU_TIME, 
SUM(LOCK_WAIT_TIME) AS TOTAL_LOCK_WAIT_TIME, 
SUM(POOL_READ_TIME + POOL_WRITE_TIME + DIRECT_READ_TIME 
+ DIRECT_WRITE_TIME) AS TOTAL_IO_WAIT_TIME, 
SUM(PREP_TIME) AS PREP_TIME, 
SUM(ROWS_READ) AS TOTAL_ROWS_READ, 
SUM(ROWS_RETURNED) AS TOTAL_ROWS_RETURNED, 
SUM(TOTAL_ACT_WAIT_TIME) AS TOTAL_ACT_WAIT_TIME, 
SUM(LOCK_ESCALS) AS TOTAL_LOCK_ESCALS, 
SUM(RECLAIM_WAIT_TIME) AS TOTAL_RECLAIM_WAIT_TIME, 
SUM(SPACEMAPPAGE_RECLAIM_WAIT_TIME) AS TOTAL_SPACEMAPPAGE_RECLAIM_WAIT_TIME 
FROM TABLE(MON_GET_PKG_CACHE_STMT (NULL, NULL, NULL, -2)) 
GROUP BY EXECUTABLE_ID) 
SELECT P.SECTION_TYPE, P.EXECUTABLE_ID, 
M.NUM_COORD_EXEC, M.NUM_COORD_EXEC_WITH_METRICS, 
M.TOTAL_STMT_EXEC_TIME, 
CASE WHEN M.NUM_COORD_EXEC_WITH_METRICS > 0 
THEN M.TOTAL_STMT_EXEC_TIME / M.NUM_COORD_EXEC_WITH_METRICS 
ELSE NULL 
END AS AVG_STMT_EXEC_TIME, 
M.TOTAL_CPU_TIME, 
CASE WHEN M.NUM_COORD_EXEC_WITH_METRICS > 0 
THEN M.TOTAL_CPU_TIME / M.NUM_COORD_EXEC_WITH_METRICS 
ELSE NULL 
END AS AVG_CPU_TIME, 
M.TOTAL_LOCK_WAIT_TIME, 
CASE WHEN M.NUM_COORD_EXEC_WITH_METRICS > 0 
THEN M.TOTAL_LOCK_WAIT_TIME / M.NUM_COORD_EXEC_WITH_METRICS 
ELSE NULL 
END AS AVG_LOCK_WAIT_TIME, 
M.TOTAL_IO_WAIT_TIME, 
CASE WHEN M.NUM_COORD_EXEC_WITH_METRICS > 0 
THEN M.TOTAL_IO_WAIT_TIME / M.NUM_COORD_EXEC_WITH_METRICS 
ELSE NULL 
END AS AVG_IO_WAIT_TIME, 
M.PREP_TIME, 
CASE WHEN M.TOTAL_ROWS_RETURNED > 0 
THEN M.TOTAL_ROWS_READ / M.TOTAL_ROWS_RETURNED 
ELSE NULL 
END AS ROWS_READ_PER_ROWS_RETURNED, 
CASE WHEN M.NUM_COORD_EXEC_WITH_METRICS > 0 
THEN M.TOTAL_ACT_WAIT_TIME / M.NUM_COORD_EXEC_WITH_METRICS 
ELSE NULL 
END AS AVG_ACT_WAIT_TIME, 
CASE WHEN M.NUM_COORD_EXEC_WITH_METRICS > 0 
THEN M.TOTAL_LOCK_ESCALS / M.NUM_COORD_EXEC_WITH_METRICS 
ELSE NULL 
END AS AVG_LOCK_ESCALS, 
CASE WHEN M.NUM_COORD_EXEC_WITH_METRICS > 0 
THEN M.TOTAL_RECLAIM_WAIT_TIME / M.NUM_COORD_EXEC_WITH_METRICS 
ELSE NULL 
END AS AVG_RECLAIM_WAIT_TIME, 
CASE WHEN M.NUM_COORD_EXEC_WITH_METRICS > 0 
THEN M.TOTAL_SPACEMAPPAGE_RECLAIM_WAIT_TIME / M.NUM_COORD_EXEC_WITH_METRICS 
ELSE NULL 
END AS AVG_SPACEMAPPAGE_RECLAIM_WAIT_TIME, 
P.STMT_TEXT 
FROM TABLE(MON_GET_PKG_CACHE_STMT (NULL, NULL, NULL, -2)) AS P 
JOIN EXEC_METRICS AS M 
ON P.EXECUTABLE_ID = M.EXECUTABLE_ID 
AND P.MEMBER = M.MIN_MEMBER 

;

-- View: SYSIBMADM.MON_SERVICE_SUBCLASS_SUMMARY
CREATE VIEW SYSIBMADM.MON_SERVICE_SUBCLASS_SUMMARY AS CREATE OR REPLACE VIEW SYSIBMADM.MON_SERVICE_SUBCLASS_SUMMARY 
(SERVICE_SUPERCLASS_NAME, SERVICE_SUBCLASS_NAME, SERVICE_CLASS_ID, 
TOTAL_APP_COMMITS, TOTAL_APP_ROLLBACKS, ACT_COMPLETED_TOTAL, 
APP_RQSTS_COMPLETED_TOTAL, AVG_RQST_CPU_TIME, ROUTINE_TIME_RQST_PERCENT, 
RQST_WAIT_TIME_PERCENT, ACT_WAIT_TIME_PERCENT, 
IO_WAIT_TIME_PERCENT, LOCK_WAIT_TIME_PERCENT, 
AGENT_WAIT_TIME_PERCENT, NETWORK_WAIT_TIME_PERCENT, 
SECTION_PROC_TIME_PERCENT, SECTION_SORT_PROC_TIME_PERCENT, 
COMPILE_PROC_TIME_PERCENT, TRANSACT_END_PROC_TIME_PERCENT, 
UTILS_PROC_TIME_PERCENT, 
AVG_LOCK_WAITS_PER_ACT, AVG_LOCK_TIMEOUTS_PER_ACT, 
AVG_DEADLOCKS_PER_ACT, AVG_LOCK_ESCALS_PER_ACT, 
ROWS_READ_PER_ROWS_RETURNED, TOTAL_BP_HIT_RATIO_PERCENT, 
TOTAL_GBP_HIT_RATIO_PERCENT, 
TOTAL_CACHING_TIER_HIT_RATIO_PERCENT, 
CF_WAIT_TIME_PERCENT, 
RECLAIM_WAIT_TIME_PERCENT, 
SPACEMAPPAGE_RECLAIM_WAIT_TIME_PERCENT) 
AS 
WITH METRICS AS 
(SELECT SERVICE_SUPERCLASS_NAME, SERVICE_SUBCLASS_NAME, SERVICE_CLASS_ID, 
SUM(TOTAL_APP_COMMITS) AS TOTAL_APP_COMMITS, 
SUM(TOTAL_APP_ROLLBACKS) AS TOTAL_APP_ROLLBACKS, 
SUM(ACT_COMPLETED_TOTAL) AS ACT_COMPLETED_TOTAL, 
SUM(ACT_COMPLETED_TOTAL + ACT_ABORTED_TOTAL) AS ACT_TOTAL, 
SUM(APP_RQSTS_COMPLETED_TOTAL) AS APP_RQSTS_COMPLETED_TOTAL, 
SUM(TOTAL_CPU_TIME) AS TOTAL_CPU_TIME, 
SUM(ROWS_READ) AS ROWS_READ, 
SUM(ROWS_RETURNED) AS ROWS_RETURNED, 
SUM(TOTAL_WAIT_TIME) AS TOTAL_WAIT_TIME, 
SUM(TOTAL_RQST_TIME) AS TOTAL_RQST_TIME, 
SUM(TOTAL_ACT_WAIT_TIME) AS TOTAL_ACT_WAIT_TIME, 
SUM(TOTAL_ACT_TIME) AS TOTAL_ACT_TIME, 
SUM(POOL_READ_TIME + POOL_WRITE_TIME + DIRECT_READ_TIME + DIRECT_WRITE_TIME) 
AS IO_WAIT_TIME, 
SUM(LOCK_WAIT_TIME) AS LOCK_WAIT_TIME, 
SUM(AGENT_WAIT_TIME) AS AGENT_WAIT_TIME, 
SUM(LOCK_WAITS) AS LOCK_WAITS, 
SUM(LOCK_TIMEOUTS) AS LOCK_TIMEOUTS, 
SUM(DEADLOCKS) AS DEADLOCKS, 
SUM(LOCK_ESCALS) AS LOCK_ESCALS, 
SUM(TCPIP_SEND_WAIT_TIME + TCPIP_RECV_WAIT_TIME + IPC_SEND_WAIT_TIME 
+ IPC_RECV_WAIT_TIME) AS NETWORK_WAIT_TIME, 
SUM(TOTAL_RQST_TIME - TOTAL_WAIT_TIME) AS PROC_TIME, 
SUM(TOTAL_SECTION_PROC_TIME) AS SECTION_PROC_TIME, 
SUM(TOTAL_SECTION_SORT_PROC_TIME) AS SECTION_SORT_PROC_TIME, 
SUM(TOTAL_COMPILE_PROC_TIME + TOTAL_IMPLICIT_COMPILE_PROC_TIME) 
AS COMPILE_PROC_TIME, 
SUM(TOTAL_COMMIT_PROC_TIME + TOTAL_ROLLBACK_PROC_TIME) 
AS TRANSACT_END_PROC_TIME, 
SUM(TOTAL_RUNSTATS_PROC_TIME + TOTAL_REORG_PROC_TIME + TOTAL_LOAD_PROC_TIME) 
AS UTILS_PROC_TIME, 
SUM(POOL_DATA_L_READS + POOL_TEMP_DATA_L_READS + POOL_INDEX_L_READS 
+ POOL_TEMP_INDEX_L_READS + POOL_XDA_L_READS + POOL_TEMP_XDA_L_READS 
+ POOL_COL_L_READS + POOL_TEMP_COL_L_READS) 
AS L_READS, 
SUM(POOL_DATA_LBP_PAGES_FOUND + POOL_INDEX_LBP_PAGES_FOUND + POOL_XDA_LBP_PAGES_FOUND 
+ POOL_COL_LBP_PAGES_FOUND) 
AS BP_PAGES_FOUND, 
SUM(TOTAL_ROUTINE_TIME) AS TOTAL_ROUTINE_TIME, 
SUM(POOL_DATA_GBP_L_READS + POOL_INDEX_GBP_L_READS + POOL_XDA_GBP_L_READS 
+ POOL_COL_GBP_L_READS) AS GBP_L_READS, 
SUM(POOL_DATA_GBP_P_READS + POOL_INDEX_GBP_P_READS + POOL_XDA_GBP_P_READS 
+ POOL_COL_GBP_P_READS) AS GBP_P_READS, 
SUM(POOL_DATA_CACHING_TIER_L_READS + POOL_INDEX_CACHING_TIER_L_READS + POOL_XDA_CACHING_TIER_L_READS 
+ POOL_COL_CACHING_TIER_L_READS) AS CACHING_TIER_L_READS, 
SUM(POOL_DATA_CACHING_TIER_PAGES_FOUND + POOL_INDEX_CACHING_TIER_PAGES_FOUND + POOL_XDA_CACHING_TIER_PAGES_FOUND 
+ POOL_COL_CACHING_TIER_PAGES_FOUND) AS CACHING_TIER_PAGES_FOUND, 
SUM(CF_WAIT_TIME) AS CF_WAIT_TIME, 
SUM(RECLAIM_WAIT_TIME) AS RECLAIM_WAIT_TIME, 
SUM(SPACEMAPPAGE_RECLAIM_WAIT_TIME) AS SPACEMAPPAGE_RECLAIM_WAIT_TIME 
FROM TABLE(MON_GET_SERVICE_SUBCLASS(NULL, NULL, -2)) 
GROUP BY SERVICE_SUPERCLASS_NAME, SERVICE_SUBCLASS_NAME, SERVICE_CLASS_ID) 
SELECT SERVICE_SUPERCLASS_NAME, SERVICE_SUBCLASS_NAME, SERVICE_CLASS_ID, 
TOTAL_APP_COMMITS, TOTAL_APP_ROLLBACKS, 
ACT_COMPLETED_TOTAL, APP_RQSTS_COMPLETED_TOTAL, 
CASE WHEN APP_RQSTS_COMPLETED_TOTAL > 0 
THEN (TOTAL_CPU_TIME / APP_RQSTS_COMPLETED_TOTAL) 
ELSE NULL 
END AS AVG_RQST_CPU_TIME, 
CASE WHEN TOTAL_RQST_TIME > 0 
THEN DEC(FLOAT(TOTAL_ROUTINE_TIME) / FLOAT(TOTAL_RQST_TIME) * 100, 5, 2) 
ELSE NULL 
END AS ROUTINE_TIME_RQST_PERCENT, 
CASE WHEN TOTAL_RQST_TIME > 0 
THEN DEC(FLOAT(TOTAL_WAIT_TIME) / FLOAT(TOTAL_RQST_TIME) * 100, 5, 2) 
ELSE NULL 
END AS RQST_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_ACT_TIME > 0 
THEN DEC(FLOAT(TOTAL_ACT_WAIT_TIME) / FLOAT(TOTAL_ACT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS ACT_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(IO_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS IO_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(LOCK_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS LOCK_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(AGENT_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS AGENT_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(NETWORK_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS NETWORK_WAIT_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(SECTION_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SECTION_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(SECTION_SORT_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SECTION_SORT_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(COMPILE_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS COMPILE_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(TRANSACT_END_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS TRANSACT_END_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(UTILS_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS UTILS_PROC_TIME_PERCENT, 
CASE WHEN ACT_TOTAL > 0 
THEN LOCK_WAITS / ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_WAITS_PER_ACT, 
CASE WHEN ACT_TOTAL > 0 
THEN LOCK_TIMEOUTS / ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_TIMEOUTS_PER_ACT, 
CASE WHEN ACT_TOTAL > 0 
THEN DEADLOCKS / ACT_TOTAL 
ELSE NULL 
END AS AVG_DEADLOCKS_PER_ACT, 
CASE WHEN ACT_TOTAL > 0 
THEN LOCK_ESCALS / ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_ESCALS_PER_ACT, 
CASE WHEN ROWS_RETURNED > 0 
THEN ROWS_READ / ROWS_RETURNED 
ELSE NULL 
END AS ROWS_READ_PER_ROWS_RETURNED, 
CASE WHEN L_READS > 0 
THEN DEC((FLOAT(BP_PAGES_FOUND) / FLOAT(L_READS)) * 100, 5, 2) 
ELSE NULL 
END AS TOTAL_BP_HIT_RATIO_PERCENT, 
CASE 
WHEN GBP_L_READS IS NULL THEN NULL 
WHEN GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(GBP_P_READS) / FLOAT(GBP_L_READS))) * 100, 5, 2) 
END AS TOTAL_GBP_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_PAGES_FOUND) / FLOAT(CACHING_TIER_L_READS)) * 100, 5, 2) 
END AS TOTAL_CACHING_TIER_HIT_RATIO_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(CF_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS CF_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(RECLAIM_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS RECLAIM_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(SPACEMAPPAGE_RECLAIM_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SPACEMAPPAGE_RECLAIM_WAIT_TIME_PERCENT 
FROM METRICS 

;

-- View: SYSIBMADM.MON_TBSP_UTILIZATION
CREATE VIEW SYSIBMADM.MON_TBSP_UTILIZATION AS CREATE OR REPLACE VIEW SYSIBMADM.MON_TBSP_UTILIZATION 
(TBSP_NAME, MEMBER, TBSP_TYPE, TBSP_CONTENT_TYPE, TBSP_STATE, 
TBSP_PAGE_SIZE, TBSP_EXTENT_SIZE, TBSP_PREFETCH_SIZE, 
TBSP_USING_AUTO_STORAGE, TBSP_AUTO_RESIZE_ENABLED, 
TBSP_TOTAL_SIZE_KB, TBSP_USABLE_SIZE_KB, 
TBSP_UTILIZATION_PERCENT, TBSP_PAGE_TOP, 
DATA_PHYSICAL_READS, DATA_HIT_RATIO_PERCENT, 
INDEX_PHYSICAL_READS, INDEX_HIT_RATIO_PERCENT, 
XDA_PHYSICAL_READS, XDA_HIT_RATIO_PERCENT, 
COL_PHYSICAL_READS, COL_HIT_RATIO_PERCENT, 
GBP_DATA_HIT_RATIO_PERCENT, GBP_INDEX_HIT_RATIO_PERCENT, 
GBP_XDA_HIT_RATIO_PERCENT, GBP_COL_HIT_RATIO_PERCENT, 
CACHING_TIER_DATA_HIT_RATIO_PERCENT, CACHING_TIER_INDEX_HIT_RATIO_PERCENT, 
CACHING_TIER_XDA_HIT_RATIO_PERCENT, CACHING_TIER_COL_HIT_RATIO_PERCENT) 
AS 
WITH TBSP_DATA AS 
(SELECT TBSP_NAME, MEMBER, 
TBSP_TYPE, TBSP_CONTENT_TYPE, TBSP_STATE, 
TBSP_PAGE_SIZE, TBSP_EXTENT_SIZE, TBSP_PREFETCH_SIZE, 
TBSP_USING_AUTO_STORAGE, TBSP_AUTO_RESIZE_ENABLED, 
(TBSP_TOTAL_PAGES * TBSP_PAGE_SIZE)/1024 AS TBSP_TOTAL_SIZE_KB, 
(TBSP_USABLE_PAGES * TBSP_PAGE_SIZE)/1024 AS TBSP_USABLE_SIZE_KB, 
TBSP_USABLE_PAGES, TBSP_USED_PAGES, TBSP_PAGE_TOP, 
(POOL_DATA_L_READS + POOL_TEMP_DATA_L_READS) AS DATA_LOGICAL_READS, 
(POOL_DATA_P_READS + POOL_TEMP_DATA_P_READS) AS DATA_PHYSICAL_READS, 
(POOL_INDEX_L_READS + POOL_TEMP_INDEX_L_READS) AS INDEX_LOGICAL_READS, 
(POOL_INDEX_P_READS + POOL_TEMP_INDEX_P_READS) AS INDEX_PHYSICAL_READS, 
(POOL_XDA_L_READS + POOL_TEMP_XDA_L_READS) AS XDA_LOGICAL_READS, 
(POOL_XDA_P_READS + POOL_TEMP_XDA_P_READS) AS XDA_PHYSICAL_READS, 
(POOL_COL_L_READS + POOL_TEMP_COL_L_READS) AS COL_LOGICAL_READS, 
(POOL_COL_P_READS + POOL_TEMP_COL_P_READS) AS COL_PHYSICAL_READS, 
(POOL_DATA_LBP_PAGES_FOUND - POOL_ASYNC_DATA_LBP_PAGES_FOUND) 
AS TOTAL_LBP_DATA_PAGES_FOUND, 
(POOL_INDEX_LBP_PAGES_FOUND - POOL_ASYNC_INDEX_LBP_PAGES_FOUND) 
AS TOTAL_LBP_INDEX_PAGES_FOUND, 
(POOL_XDA_LBP_PAGES_FOUND - POOL_ASYNC_XDA_LBP_PAGES_FOUND) 
AS TOTAL_LBP_XDA_PAGES_FOUND, 
(POOL_COL_LBP_PAGES_FOUND - POOL_ASYNC_COL_LBP_PAGES_FOUND) 
AS TOTAL_LBP_COL_PAGES_FOUND, 
POOL_DATA_GBP_P_READS, POOL_INDEX_GBP_P_READS, POOL_XDA_GBP_P_READS, POOL_COL_GBP_P_READS, 
POOL_DATA_GBP_L_READS, POOL_INDEX_GBP_L_READS, POOL_XDA_GBP_L_READS, POOL_COL_GBP_L_READS, 
(POOL_DATA_CACHING_TIER_L_READS - POOL_ASYNC_DATA_CACHING_TIER_READS) 
AS CACHING_TIER_DATA_L_READS, 
(POOL_DATA_CACHING_TIER_PAGES_FOUND - POOL_ASYNC_DATA_CACHING_TIER_PAGES_FOUND) 
AS CACHING_TIER_DATA_PAGES_FOUND, 
(POOL_INDEX_CACHING_TIER_L_READS - POOL_ASYNC_INDEX_CACHING_TIER_READS) 
AS CACHING_TIER_INDEX_L_READS, 
(POOL_INDEX_CACHING_TIER_PAGES_FOUND - POOL_ASYNC_INDEX_CACHING_TIER_PAGES_FOUND) 
AS CACHING_TIER_INDEX_PAGES_FOUND, 
(POOL_XDA_CACHING_TIER_L_READS - POOL_ASYNC_XDA_CACHING_TIER_READS) 
AS CACHING_TIER_XDA_L_READS, 
(POOL_XDA_CACHING_TIER_PAGES_FOUND - POOL_ASYNC_XDA_CACHING_TIER_PAGES_FOUND) 
AS CACHING_TIER_XDA_PAGES_FOUND, 
(POOL_COL_CACHING_TIER_L_READS - POOL_ASYNC_COL_CACHING_TIER_READS) 
AS CACHING_TIER_COL_L_READS, 
(POOL_COL_CACHING_TIER_PAGES_FOUND - POOL_ASYNC_COL_CACHING_TIER_PAGES_FOUND) 
AS CACHING_TIER_COL_PAGES_FOUND 
FROM TABLE(MON_GET_TABLESPACE(NULL, -2))) 
SELECT TBSP_NAME, MEMBER, 
TBSP_TYPE, TBSP_CONTENT_TYPE, TBSP_STATE, 
TBSP_PAGE_SIZE, TBSP_EXTENT_SIZE, TBSP_PREFETCH_SIZE, 
TBSP_USING_AUTO_STORAGE, TBSP_AUTO_RESIZE_ENABLED, 
TBSP_TOTAL_SIZE_KB, TBSP_USABLE_SIZE_KB, 
CASE WHEN TBSP_USABLE_PAGES > 0 
THEN DEC((FLOAT(TBSP_USED_PAGES)/FLOAT(TBSP_USABLE_PAGES)) * 100,5,2) 
ELSE NULL 
END AS TBSP_UTILIZATION_PERCENT, 
TBSP_PAGE_TOP, 
DATA_PHYSICAL_READS, 
CASE WHEN DATA_LOGICAL_READS > 0 
THEN DEC((FLOAT(TOTAL_LBP_DATA_PAGES_FOUND) / FLOAT(DATA_LOGICAL_READS)) 
* 100,5,2) 
ELSE NULL 
END AS DATA_HIT_RATIO_PERCENT, 
INDEX_PHYSICAL_READS, 
CASE WHEN INDEX_LOGICAL_READS > 0 
THEN DEC((FLOAT(TOTAL_LBP_INDEX_PAGES_FOUND) / FLOAT(INDEX_LOGICAL_READS)) 
* 100,5,2) 
ELSE NULL 
END AS INDEX_HIT_RATIO_PERCENT, 
XDA_PHYSICAL_READS, 
CASE WHEN XDA_LOGICAL_READS > 0 
THEN DEC((FLOAT(TOTAL_LBP_XDA_PAGES_FOUND) / FLOAT(XDA_LOGICAL_READS)) 
* 100,5,2) 
ELSE NULL 
END AS XDA_HIT_RATIO_PERCENT, 
COL_PHYSICAL_READS, 
CASE WHEN COL_LOGICAL_READS > 0 
THEN DEC((FLOAT(TOTAL_LBP_COL_PAGES_FOUND) / FLOAT(COL_LOGICAL_READS)) 
* 100, 5, 2) 
ELSE NULL 
END AS COL_HIT_RATIO_PERCENT, 
CASE 
WHEN POOL_DATA_GBP_L_READS IS NULL THEN NULL 
WHEN POOL_DATA_GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(POOL_DATA_GBP_P_READS) / FLOAT(POOL_DATA_GBP_L_READS))) 
* 100, 5, 2) 
END AS GBP_DATA_HIT_RATIO_PERCENT, 
CASE 
WHEN POOL_INDEX_GBP_L_READS IS NULL THEN NULL 
WHEN POOL_INDEX_GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(POOL_INDEX_GBP_P_READS) / FLOAT(POOL_INDEX_GBP_L_READS))) 
* 100, 5, 2) 
END AS GBP_INDEX_HIT_RATIO_PERCENT, 
CASE 
WHEN POOL_XDA_GBP_L_READS IS NULL THEN NULL 
WHEN POOL_XDA_GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(POOL_XDA_GBP_P_READS) / FLOAT(POOL_XDA_GBP_L_READS))) 
* 100, 5, 2) 
END AS GBP_XDA_HIT_RATIO_PERCENT, 
CASE 
WHEN POOL_COL_GBP_L_READS IS NULL THEN NULL 
WHEN POOL_COL_GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(POOL_COL_GBP_P_READS) / FLOAT(POOL_COL_GBP_L_READS))) 
* 100, 5, 2) 
END AS GBP_COL_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_DATA_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_DATA_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_DATA_PAGES_FOUND) / FLOAT(CACHING_TIER_DATA_L_READS)) 
* 100, 5, 2) 
END AS CACHING_TIER_DATA_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_INDEX_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_INDEX_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_INDEX_PAGES_FOUND) / FLOAT(CACHING_TIER_INDEX_L_READS)) 
* 100, 5, 2) 
END AS CACHING_TIER_INDEX_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_XDA_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_XDA_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_XDA_PAGES_FOUND) / FLOAT(CACHING_TIER_XDA_L_READS)) 
* 100, 5, 2) 
END AS CACHING_TIER_XDA_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_COL_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_COL_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_COL_PAGES_FOUND) / FLOAT(CACHING_TIER_COL_L_READS)) 
* 100, 5, 2) 
END AS CACHING_TIER_COL_HIT_RATIO_PERCENT 
FROM TBSP_DATA 

;

-- View: SYSIBMADM.MON_TRANSACTION_LOG_UTILIZATION
CREATE VIEW SYSIBMADM.MON_TRANSACTION_LOG_UTILIZATION AS CREATE OR REPLACE VIEW SYSIBMADM.MON_TRANSACTION_LOG_UTILIZATION 
( LOG_UTILIZATION_PERCENT, TOTAL_LOG_USED_KB, TOTAL_LOG_AVAILABLE_KB, 
TOTAL_LOG_USED_TOP_KB, MEMBER) 
AS SELECT 
CASE (TOTAL_LOG_AVAILABLE) 
WHEN -1 THEN DEC(-1,5,2) 
ELSE DEC(100 * (FLOAT(TOTAL_LOG_USED)/FLOAT(TOTAL_LOG_USED + TOTAL_LOG_AVAILABLE)), 5,2) 
END, 
TOTAL_LOG_USED / 1024, 
CASE (TOTAL_LOG_AVAILABLE) 
WHEN -1 THEN -1 
ELSE TOTAL_LOG_AVAILABLE / 1024 
END, 
TOT_LOG_USED_TOP / 1024, MEMBER 
FROM TABLE(SYSPROC.MON_GET_TRANSACTION_LOG(-2)) 

;

-- View: SYSIBMADM.MON_WORKLOAD_SUMMARY
CREATE VIEW SYSIBMADM.MON_WORKLOAD_SUMMARY AS CREATE OR REPLACE VIEW SYSIBMADM.MON_WORKLOAD_SUMMARY 
(WORKLOAD_NAME, WORKLOAD_ID, 
TOTAL_APP_COMMITS, TOTAL_APP_ROLLBACKS, ACT_COMPLETED_TOTAL, 
APP_RQSTS_COMPLETED_TOTAL, AVG_RQST_CPU_TIME, ROUTINE_TIME_RQST_PERCENT, 
RQST_WAIT_TIME_PERCENT, ACT_WAIT_TIME_PERCENT, 
IO_WAIT_TIME_PERCENT, LOCK_WAIT_TIME_PERCENT, 
AGENT_WAIT_TIME_PERCENT, NETWORK_WAIT_TIME_PERCENT, 
SECTION_PROC_TIME_PERCENT, SECTION_SORT_PROC_TIME_PERCENT, 
COMPILE_PROC_TIME_PERCENT, TRANSACT_END_PROC_TIME_PERCENT, 
UTILS_PROC_TIME_PERCENT, 
AVG_LOCK_WAITS_PER_ACT, AVG_LOCK_TIMEOUTS_PER_ACT, 
AVG_DEADLOCKS_PER_ACT, AVG_LOCK_ESCALS_PER_ACT, 
ROWS_READ_PER_ROWS_RETURNED, TOTAL_BP_HIT_RATIO_PERCENT, 
TOTAL_GBP_HIT_RATIO_PERCENT, 
TOTAL_CACHING_TIER_HIT_RATIO_PERCENT, 
CF_WAIT_TIME_PERCENT, 
RECLAIM_WAIT_TIME_PERCENT, 
SPACEMAPPAGE_RECLAIM_WAIT_TIME_PERCENT) 
AS 
WITH METRICS AS 
(SELECT WORKLOAD_NAME, WORKLOAD_ID, 
SUM(TOTAL_APP_COMMITS) AS TOTAL_APP_COMMITS, 
SUM(TOTAL_APP_ROLLBACKS) AS TOTAL_APP_ROLLBACKS, 
SUM(ACT_COMPLETED_TOTAL) AS ACT_COMPLETED_TOTAL, 
SUM(ACT_COMPLETED_TOTAL + ACT_ABORTED_TOTAL) AS ACT_TOTAL, 
SUM(APP_RQSTS_COMPLETED_TOTAL) AS APP_RQSTS_COMPLETED_TOTAL, 
SUM(TOTAL_CPU_TIME) AS TOTAL_CPU_TIME, 
SUM(ROWS_READ) AS ROWS_READ, 
SUM(ROWS_RETURNED) AS ROWS_RETURNED, 
SUM(TOTAL_WAIT_TIME) AS TOTAL_WAIT_TIME, 
SUM(TOTAL_RQST_TIME) AS TOTAL_RQST_TIME, 
SUM(TOTAL_ACT_WAIT_TIME) AS TOTAL_ACT_WAIT_TIME, 
SUM(TOTAL_ACT_TIME) AS TOTAL_ACT_TIME, 
SUM(POOL_READ_TIME + POOL_WRITE_TIME + DIRECT_READ_TIME + DIRECT_WRITE_TIME) 
AS IO_WAIT_TIME, 
SUM(LOCK_WAIT_TIME) AS LOCK_WAIT_TIME, 
SUM(AGENT_WAIT_TIME) AS AGENT_WAIT_TIME, 
SUM(LOCK_WAITS) AS LOCK_WAITS, 
SUM(LOCK_TIMEOUTS) AS LOCK_TIMEOUTS, 
SUM(DEADLOCKS) AS DEADLOCKS, 
SUM(LOCK_ESCALS) AS LOCK_ESCALS, 
SUM(TCPIP_SEND_WAIT_TIME + TCPIP_RECV_WAIT_TIME + IPC_SEND_WAIT_TIME 
+ IPC_RECV_WAIT_TIME) AS NETWORK_WAIT_TIME, 
SUM(TOTAL_RQST_TIME - TOTAL_WAIT_TIME) AS PROC_TIME, 
SUM(TOTAL_SECTION_PROC_TIME) AS SECTION_PROC_TIME, 
SUM(TOTAL_SECTION_SORT_PROC_TIME) AS SECTION_SORT_PROC_TIME, 
SUM(TOTAL_COMPILE_PROC_TIME + TOTAL_IMPLICIT_COMPILE_PROC_TIME) 
AS COMPILE_PROC_TIME, 
SUM(TOTAL_COMMIT_PROC_TIME + TOTAL_ROLLBACK_PROC_TIME) 
AS TRANSACT_END_PROC_TIME, 
SUM(TOTAL_RUNSTATS_PROC_TIME + TOTAL_REORG_PROC_TIME + TOTAL_LOAD_PROC_TIME) 
AS UTILS_PROC_TIME, 
SUM(POOL_DATA_L_READS + POOL_TEMP_DATA_L_READS + POOL_INDEX_L_READS 
+ POOL_TEMP_INDEX_L_READS + POOL_XDA_L_READS + POOL_TEMP_XDA_L_READS 
+ POOL_COL_L_READS + POOL_TEMP_COL_L_READS) 
AS L_READS, 
SUM(POOL_DATA_LBP_PAGES_FOUND + POOL_INDEX_LBP_PAGES_FOUND + POOL_XDA_LBP_PAGES_FOUND 
+ POOL_COL_LBP_PAGES_FOUND) 
AS BP_PAGES_FOUND, 
SUM(TOTAL_ROUTINE_TIME) AS TOTAL_ROUTINE_TIME, 
SUM(POOL_DATA_GBP_L_READS + POOL_INDEX_GBP_L_READS + POOL_XDA_GBP_L_READS 
+ POOL_COL_GBP_L_READS) AS GBP_L_READS, 
SUM(POOL_DATA_GBP_P_READS + POOL_INDEX_GBP_P_READS + POOL_XDA_GBP_P_READS 
+ POOL_COL_GBP_P_READS) AS GBP_P_READS, 
SUM(POOL_DATA_CACHING_TIER_L_READS + POOL_INDEX_CACHING_TIER_L_READS + POOL_XDA_CACHING_TIER_L_READS 
+ POOL_COL_CACHING_TIER_L_READS) AS CACHING_TIER_L_READS, 
SUM(POOL_DATA_CACHING_TIER_PAGES_FOUND + POOL_INDEX_CACHING_TIER_PAGES_FOUND + POOL_XDA_CACHING_TIER_PAGES_FOUND 
+ POOL_COL_CACHING_TIER_PAGES_FOUND) AS CACHING_TIER_PAGES_FOUND, 
SUM(CF_WAIT_TIME) AS CF_WAIT_TIME, 
SUM(RECLAIM_WAIT_TIME) AS RECLAIM_WAIT_TIME, 
SUM(SPACEMAPPAGE_RECLAIM_WAIT_TIME) AS SPACEMAPPAGE_RECLAIM_WAIT_TIME 
FROM TABLE(MON_GET_WORKLOAD(NULL, -2)) 
GROUP BY WORKLOAD_NAME, WORKLOAD_ID) 
SELECT WORKLOAD_NAME, WORKLOAD_ID, 
TOTAL_APP_COMMITS, TOTAL_APP_ROLLBACKS, 
ACT_COMPLETED_TOTAL, APP_RQSTS_COMPLETED_TOTAL, 
CASE WHEN APP_RQSTS_COMPLETED_TOTAL > 0 
THEN (TOTAL_CPU_TIME / APP_RQSTS_COMPLETED_TOTAL) 
ELSE NULL 
END AS AVG_RQST_CPU_TIME, 
CASE WHEN TOTAL_RQST_TIME > 0 
THEN DEC(FLOAT(TOTAL_ROUTINE_TIME) / FLOAT(TOTAL_RQST_TIME) * 100, 5, 2) 
ELSE NULL 
END AS ROUTINE_TIME_RQST_PERCENT, 
CASE WHEN TOTAL_RQST_TIME > 0 
THEN DEC(FLOAT(TOTAL_WAIT_TIME) / FLOAT(TOTAL_RQST_TIME) * 100, 5, 2) 
ELSE NULL 
END AS RQST_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_ACT_TIME > 0 
THEN DEC(FLOAT(TOTAL_ACT_WAIT_TIME) / FLOAT(TOTAL_ACT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS ACT_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(IO_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS IO_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(LOCK_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS LOCK_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(AGENT_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS AGENT_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(NETWORK_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS NETWORK_WAIT_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(SECTION_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SECTION_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(SECTION_SORT_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SECTION_SORT_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(COMPILE_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS COMPILE_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(TRANSACT_END_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS TRANSACT_END_PROC_TIME_PERCENT, 
CASE WHEN PROC_TIME > 0 
THEN DEC(FLOAT(UTILS_PROC_TIME) / FLOAT(PROC_TIME) * 100, 5, 2) 
ELSE NULL 
END AS UTILS_PROC_TIME_PERCENT, 
CASE WHEN ACT_TOTAL > 0 
THEN LOCK_WAITS / ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_WAITS_PER_ACT, 
CASE WHEN ACT_TOTAL > 0 
THEN LOCK_TIMEOUTS / ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_TIMEOUTS_PER_ACT, 
CASE WHEN ACT_TOTAL > 0 
THEN DEADLOCKS / ACT_TOTAL 
ELSE NULL 
END AS AVG_DEADLOCKS_PER_ACT, 
CASE WHEN ACT_TOTAL > 0 
THEN LOCK_ESCALS / ACT_TOTAL 
ELSE NULL 
END AS AVG_LOCK_ESCALS_PER_ACT, 
CASE WHEN ROWS_RETURNED > 0 
THEN ROWS_READ / ROWS_RETURNED 
ELSE NULL 
END AS ROWS_READ_PER_ROWS_RETURNED, 
CASE WHEN L_READS > 0 
THEN DEC((FLOAT(BP_PAGES_FOUND) / FLOAT(L_READS)) * 100, 5, 2) 
ELSE NULL 
END AS TOTAL_BP_HIT_RATIO_PERCENT, 
CASE 
WHEN GBP_L_READS IS NULL THEN NULL 
WHEN GBP_L_READS = 0 THEN NULL 
ELSE DEC((1 - (FLOAT(GBP_P_READS) / FLOAT(GBP_L_READS))) * 100, 5, 2) 
END AS TOTAL_GBP_HIT_RATIO_PERCENT, 
CASE 
WHEN CACHING_TIER_L_READS IS NULL THEN NULL 
WHEN CACHING_TIER_L_READS = 0 THEN NULL 
ELSE DEC((FLOAT(CACHING_TIER_PAGES_FOUND) / FLOAT(CACHING_TIER_L_READS)) * 100, 5, 2) 
END AS TOTAL_CACHING_TIER_HIT_RATIO_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(CF_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS CF_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(RECLAIM_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS RECLAIM_WAIT_TIME_PERCENT, 
CASE WHEN TOTAL_WAIT_TIME > 0 
THEN DEC(FLOAT(SPACEMAPPAGE_RECLAIM_WAIT_TIME) / FLOAT(TOTAL_WAIT_TIME) * 100, 5, 2) 
ELSE NULL 
END AS SPACEMAPPAGE_RECLAIM_WAIT_TIME_PERCENT 
FROM METRICS 

;

-- View: SYSIBMADM.NOTIFICATIONLIST
CREATE VIEW SYSIBMADM.NOTIFICATIONLIST AS CREATE OR REPLACE VIEW SYSIBMADM.NOTIFICATIONLIST 
(NAME, TYPE) 
AS SELECT 
NOTIFICATIONLIST.NAME, NOTIFICATIONLIST.TYPE 
FROM TABLE(SYSPROC.HEALTH_GET_NOTIFICATION_LIST()) AS NOTIFICATIONLIST 

;

-- View: SYSIBMADM.OBJECTOWNERS
CREATE VIEW SYSIBMADM.OBJECTOWNERS AS CREATE OR REPLACE VIEW SYSIBMADM.OBJECTOWNERS 
(OWNER, OWNERTYPE, OBJECTNAME, OBJECTSCHEMA, OBJECTTYPE ) 
AS ( 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), NAME, CREATOR, 
CASE type 
WHEN 'A' THEN 'ALIAS' 
WHEN 'G' THEN 'CREATED TEMPORARY TABLE' 
WHEN 'H' THEN 'HIERARCHY TABLE' 
WHEN 'L' THEN 'DETACHED TABLE' 
WHEN 'N' THEN 'NICKNAME' 
WHEN 'S' THEN 'MATERIALIZED QUERY TABLE' 
WHEN 'T' THEN 'TABLE' 
WHEN 'U' THEN 'TYPED TABLE' 
WHEN 'V' THEN 'VIEW' 
WHEN 'W' THEN 'TYPED VIEW' 
END 
FROM SYSIBM.SYSTABLES 
UNION ALL 
SELECT OWNER, CAST(OWNERTYPE AS VARCHAR(1)), NAME, NAME, 'SCHEMA' 
FROM SYSIBM.SYSSCHEMATA 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), SPECIFICNAME, ROUTINESCHEMA, 
CASE ROUTINETYPE 
WHEN 'F' THEN 'FUNCTION' 
WHEN 'M' THEN 'METHOD' 
WHEN 'P' THEN 'PROCEDURE' 
END 
FROM SYSIBM.SYSROUTINES 
WHERE ROUTINEMODULEID IS NULL 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), NAME, CREATOR, 'INDEX' 
FROM SYSIBM.SYSINDEXES 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), TBSPACE, '', 
CASE TBSPACETYPE 
WHEN 'S' THEN 'SYSTEM MANAGED SPACE' 
WHEN 'D' THEN 'DATABASE MANAGED SPACE' 
END 
FROM SYSIBM.SYSTABLESPACES 
UNION ALL 
SELECT BOUNDBY, CAST(BOUNDBYTYPE AS VARCHAR(1)), NAME, CREATOR, 'DB2 PACKAGE' 
FROM SYSIBM.SYSPLAN 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), SEQNAME, SEQSCHEMA, 
CASE SEQTYPE 
WHEN 'S' THEN 'SEQUENCE' 
WHEN 'I' THEN 'SEQUENCE' 
WHEN 'A' THEN 'ALIAS' 
END 
FROM SYSIBM.SYSSEQUENCES 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), IENAME, IESCHEMA, 'INDEXEXTENSIONS' 
FROM SYSIBM.SYSINDEXEXTENSIONS 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), NAME, '', 'DBPARTITIONGROUP' 
FROM SYSIBM.SYSNODEGROUPS 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), NAME, '', 'EVENTMONITORS' 
FROM SYSIBM.SYSEVENTMONITORS 
UNION ALL 
SELECT OWNER, CAST(OWNERTYPE AS VARCHAR(1)), XSROBJECTNAME, XSROBJECTSCHEMA, 
CASE OBJECTTYPE 
WHEN 'S' THEN 'XML SCHEMA' 
WHEN 'D' THEN 'DTD' 
WHEN 'E' THEN 'EXTERNAL ENTITY' 
END 
FROM SYSIBM.SYSXSROBJECTS 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), TYPE_MAPPING, TYPESCHEMA, 'TYPE_MAPPINGS' 
FROM SYSIBM.SYSTYPEMAPPINGS 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), FUNCTION_MAPPING, FUNCSCHEMA, 'FUNCTION_MAPPING' 
FROM SYSIBM.SYSFUNCMAPPINGS 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), NAME, SCHEMA, 'DATATYPE' 
FROM SYSIBM.SYSDATATYPES 
WHERE TYPEMODULEID IS NULL 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), NAME, SCHEMA, 'TRIGGER' 
FROM SYSIBM.SYSTRIGGERS 
UNION ALL 
SELECT DEFINER, CAST(DEFINERTYPE AS VARCHAR(1)), NAME, TBCREATOR, 'TABLE CONSTRAINT' 
FROM SYSIBM.SYSTABCONST 
UNION ALL 
SELECT OWNER, CAST(OWNERTYPE AS VARCHAR(1)), VARNAME, VARSCHEMA, 'GLOBAL VARIABLE' 
FROM SYSIBM.SYSVARIABLES 
WHERE VARMODULEID IS NULL 
UNION ALL 
SELECT OWNER, CAST(OWNERTYPE AS VARCHAR(1)), MODULENAME, MODULESCHEMA, 
CASE MODULETYPE 
WHEN 'M' THEN 'MODULE' 
WHEN 'A' THEN 'ALIAS' 
END 
FROM SYSIBM.SYSMODULES 
UNION ALL 
SELECT OWNER, CAST(OWNERTYPE AS VARCHAR(1)), CONTROLNAME, CONTROLSCHEMA, 
CASE CONTROLTYPE 
WHEN 'R' THEN 'PERMISSION' 
WHEN 'C' THEN 'MASK' 
END 
FROM SYSIBM.SYSCONTROLS 
) 

;

-- View: SYSIBMADM.PDLOGMSGS_LAST24HOURS
CREATE VIEW SYSIBMADM.PDLOGMSGS_LAST24HOURS AS CREATE OR REPLACE VIEW SYSIBMADM.PDLOGMSGS_LAST24HOURS 
(TIMESTAMP, TIMEZONE, INSTANCENAME, DBPARTITIONNUM, DBNAME, PID, 
PROCESSNAME,TID, APPL_ID, COMPONENT, FUNCTION, PROBE, MSGNUM, 
MSGTYPE, MSGSEVERITY, MSG, MEMBER ) 
AS SELECT 
MSGS.TIMESTAMP, MSGS.TIMEZONE, MSGS.INSTANCENAME, MSGS.DBPARTITIONNUM, 
MSGS.DBNAME, MSGS.PID, MSGS.PROCESSNAME, MSGS.TID, MSGS.APPL_ID, 
MSGS.COMPONENT, MSGS.FUNCTION, MSGS.PROBE, MSGS.MSGNUM, MSGS.MSGTYPE, 
MSGS.MSGSEVERITY, MSGS.MSG, MSGS.MEMBER 
FROM TABLE(SYSPROC.PD_GET_LOG_MSGS( CURRENT_TIMESTAMP - 1 DAY, -2)) AS MSGS 

;

-- View: SYSIBMADM.PRIVILEGES
CREATE VIEW SYSIBMADM.PRIVILEGES AS CREATE OR REPLACE VIEW SYSIBMADM.PRIVILEGES 
( AUTHID, AUTHIDTYPE, PRIVILEGE, GRANTABLE, OBJECTNAME, OBJECTSCHEMA, OBJECTTYPE, PARENTOBJECTNAME, PARENTOBJECTTYPE ) 
AS 
WITH 
TABLEVIEWNICKNAME(OWNER, OWNERTYPE, OBJECTNAME, OBJECTSCHEMA, OBJECTTYPE) 
AS ( 
SELECT DEFINER, 'U', NAME, CREATOR, 
CASE type 
WHEN 'A' THEN 'ALIAS' 
WHEN 'G' THEN 'CREATED TEMPORARY TABLE' 
WHEN 'H' THEN 'HIERARCHY TABLE' 
WHEN 'L' THEN 'DETACHED TABLE' 
WHEN 'N' THEN 'NICKNAME' 
WHEN 'S' THEN 'MATERIALIZED QUERY TABLE' 
WHEN 'T' THEN 'TABLE' 
WHEN 'U' THEN 'TYPED TABLE' 
WHEN 'V' THEN 'VIEW' 
WHEN 'W' THEN 'TYPED VIEW' 
END 
FROM SYSIBM.SYSTABLES ), 
TABLEVIEWNICKNAMEAUTH (GRANTEE, GRANTEETYPE, TCREATOR, TTNAME, CONTROLAUTH, 
ALTERAUTH, DELETEAUTH, INDEXAUTH, INSERTAUTH, SELECTAUTH, 
REFAUTH, UPDATEAUTH, TYPE) 
AS ( 
SELECT A.GRANTEE, A.GRANTEETYPE, A.TABSCHEMA, A.TABNAME, A.CONTROLAUTH, A.ALTERAUTH, 
A.DELETEAUTH, A.INDEXAUTH, A.INSERTAUTH, A.SELECTAUTH, A.REFAUTH, A.UPDATEAUTH, 
B.OBJECTTYPE 
FROM SYSCAT.TABAUTH A, TABLEVIEWNICKNAME B 
WHERE A.TABSCHEMA = B.OBJECTSCHEMA AND A.TABNAME = B.OBJECTNAME) 
SELECT GRANTEE, GRANTEETYPE, CAST('CONTROL' AS VARCHAR(11)), 
CASE CONTROLAUTH 
WHEN 'Y' THEN 'N' 
END, 
TTNAME, TCREATOR, TYPE, '', '' 
FROM TABLEVIEWNICKNAMEAUTH WHERE CONTROLAUTH != 'N' 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('ALTER' AS VARCHAR(11)), 
CASE ALTERAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
TTNAME, TCREATOR, TYPE, '', '' 
FROM TABLEVIEWNICKNAMEAUTH WHERE ALTERAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('DELETE' AS VARCHAR(11)), 
CASE DELETEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
TTNAME, TCREATOR, TYPE, '' , '' 
FROM TABLEVIEWNICKNAMEAUTH WHERE DELETEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('INDEX' AS VARCHAR(11)), 
CASE INDEXAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
TTNAME, TCREATOR, TYPE, '', '' 
FROM TABLEVIEWNICKNAMEAUTH WHERE INDEXAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('INSERT' AS VARCHAR(11)), 
CASE INSERTAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
TTNAME, TCREATOR, TYPE, '', '' 
FROM TABLEVIEWNICKNAMEAUTH WHERE INSERTAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('SELECT' AS VARCHAR(11)), 
CASE SELECTAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
TTNAME, TCREATOR, TYPE, '', '' 
FROM TABLEVIEWNICKNAMEAUTH WHERE SELECTAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('REFERENCE' AS VARCHAR(11)), 
CASE DELETEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
TTNAME, TCREATOR, TYPE, '', '' 
FROM TABLEVIEWNICKNAMEAUTH WHERE REFAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('UPDATE' AS VARCHAR(11)), 
CASE UPDATEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
TTNAME, TCREATOR, TYPE, '', '' 
FROM TABLEVIEWNICKNAMEAUTH WHERE UPDATEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('ALTERIN' AS VARCHAR(11)), 
CASE ALTERINAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
'', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE ALTERINAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('CREATEIN' AS VARCHAR(11)), 
CASE CREATEINAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
'', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE CREATEINAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('DROPIN' AS VARCHAR(11)), 
CASE DROPINAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
'', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE DROPINAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('SELECTIN' AS VARCHAR(11)), 
CASE SELECTINAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
'', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE SELECTINAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('INSERTIN' AS VARCHAR(11)), 
CASE INSERTINAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
'', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE INSERTINAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('UPDATEIN' AS VARCHAR(11)), 
CASE UPDATEINAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
'', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE UPDATEINAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('DELETEIN' AS VARCHAR(11)), 
CASE DELETEINAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
'', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE DELETEINAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('EXECUTEIN' AS VARCHAR(11)), 
CASE EXECUTEINAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
'', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE EXECUTEINAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('SCHEMAADM' AS VARCHAR(11)), 
'N', '', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE SCHEMAADMAUTH = 'Y' 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('ACCESSCTRL' AS VARCHAR(11)), 
'N', '', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE ACCESSCTRLAUTH = 'Y' 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('DATAACCESS' AS VARCHAR(11)), 
'N', '', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE DATAACCESSAUTH = 'Y' 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('LOAD' AS VARCHAR(11)), 
'N', '', SCHEMANAME, 'SCHEMA', '', '' 
FROM SYSCAT.SCHEMAAUTH WHERE LOADAUTH = 'Y' 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('CONTROL' AS VARCHAR(11)), 'N', INDNAME, INDSCHEMA, 'INDEX', '', '' 
FROM SYSCAT.INDEXAUTH WHERE CONTROLAUTH = 'Y' 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('USE' AS VARCHAR(11)), 
CASE USEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
TBSPACE, '', 'TABLESPACE', '', '' 
FROM SYSCAT.TBSPACEAUTH WHERE USEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('EXECUTE' AS VARCHAR(11)), 
CASE EXECUTEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
SPECIFICNAME, SCHEMA, 
CASE ROUTINETYPE 
WHEN 'F' THEN 'FUNCTION' 
WHEN 'M' THEN 'METHOD' 
WHEN 'P' THEN 'PROCEDURE' 
END, 
'', '' 
FROM SYSCAT.ROUTINEAUTH WHERE EXECUTEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('CONTROL' AS VARCHAR(11)), 'N', PKGNAME, PKGSCHEMA, 
'DB2 PACKAGE', '', '' 
FROM SYSCAT.PACKAGEAUTH WHERE CONTROLAUTH = 'Y' 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('BIND' AS VARCHAR(11)), 
CASE BINDAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
PKGNAME, PKGSCHEMA, 'DB2 PACKAGE', '', '' 
FROM SYSCAT.PACKAGEAUTH WHERE BINDAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('EXECUTE' AS VARCHAR(11)), 
CASE EXECUTEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
PKGNAME, PKGSCHEMA, 'DB2 PACKAGE', '', '' 
FROM SYSCAT.PACKAGEAUTH WHERE EXECUTEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('USAGE' AS VARCHAR(11)), 
CASE USAGEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
SEQNAME, SEQSCHEMA, 'SEQUENCE', '', '' 
FROM SYSCAT.SEQUENCEAUTH 
WHERE USAGEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('ALTER' AS VARCHAR(11)), 
CASE ALTERAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
SEQNAME, SEQSCHEMA, 'SEQUENCE', '', '' 
FROM SYSCAT.SEQUENCEAUTH 
WHERE ALTERAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('PASSTHROUGH' AS VARCHAR(11)), '-', 
SERVERNAME, '', 'DATA SOURCE', '', '' FROM SYSCAT.PASSTHRUAUTH 
UNION ALL 
SELECT A.GRANTEE, A.GRANTEETYPE, CAST('USAGE' AS VARCHAR(11)), 
CASE A.USAGEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
B.XSROBJECTNAME, B.XSROBJECTSCHEMA, 'XML OBJECT', '', '' 
FROM SYSCAT.XSROBJECTAUTH AS A, SYSIBM.SYSXSROBJECTS AS B 
WHERE A.OBJECTID = B.XSROBJECTID AND A.USAGEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('READ' AS VARCHAR(11)), 
CASE READAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
VARNAME, VARSCHEMA, 'GLOBAL VARIABLE', '', '' 
FROM SYSCAT.VARIABLEAUTH 
WHERE READAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('WRITE' AS VARCHAR(11)), 
CASE WRITEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
VARNAME, VARSCHEMA, 'GLOBAL VARIABLE', '', '' 
FROM SYSCAT.VARIABLEAUTH 
WHERE WRITEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT A.GRANTEE, A.GRANTEETYPE, CAST('USAGE' AS VARCHAR(11)), 
CASE A.USAGEAUTH 
WHEN 'G' THEN 'Y' 
WHEN 'Y' THEN 'N' 
END, 
B.WORKLOADNAME, '', 'WORKLOAD', '', '' 
FROM SYSCAT.WORKLOADAUTH AS A, SYSIBM.SYSWORKLOADS AS B 
WHERE A.WORKLOADID = B.WORKLOADID AND A.USAGEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, CAST('EXECUTE' AS VARCHAR(11)), 
CASE EXECUTEAUTH 
WHEN 'G' THEN 'Y' 
ELSE 'N' 
END, 
MODULENAME, MODULESCHEMA, 'MODULE', '', '' 
FROM SYSCAT.MODULEAUTH 
WHERE EXECUTEAUTH IN ('G', 'Y') 
UNION ALL 
SELECT GRANTEE, GRANTEETYPE, 
CASE PRIVTYPE 
WHEN 'U' THEN 'UPDATE' 
WHEN 'R' THEN 'REFERENCE' 
END, 
CASE GRANTABLE 
WHEN 'G' THEN 'Y' 
ELSE 'N' 
END, 
COLNAME, TABSCHEMA, 'COLUMN', TABNAME, 'TABLE' 
FROM SYSCAT.COLAUTH 
UNION ALL 
SELECT TRUSTEDID, TRUSTEDIDTYPE, CAST('SET SESSION' AS VARCHAR(11)), 
'N', SURROGATEAUTHID, '', 
CASE SURROGATEAUTHIDTYPE 
WHEN 'G' THEN 'GROUP' 
WHEN 'U' THEN 'USER' 
END, 
'', '' 
FROM SYSCAT.SURROGATEAUTHIDS 
WHERE TRUSTEDIDTYPE IN ('G', 'U') 

;

-- View: SYSIBMADM.QUERY_PREP_COST
CREATE VIEW SYSIBMADM.QUERY_PREP_COST AS CREATE OR REPLACE VIEW SYSIBMADM.QUERY_PREP_COST 
( SNAPSHOT_TIMESTAMP, NUM_EXECUTIONS, AVERAGE_EXECUTION_TIME_S, 
AVERAGE_EXECUTION_TIME_MS, PREP_TIME_MS, 
PREP_TIME_PERCENT, STMT_TEXT, DBPARTITIONNUM, MEMBER) 
AS SELECT 
SNAPSHOT_TIMESTAMP, NUM_EXECUTIONS, TOTAL_EXEC_TIME / NUM_EXECUTIONS, 
((TOTAL_EXEC_TIME - ((TOTAL_EXEC_TIME / NUM_EXECUTIONS) * NUM_EXECUTIONS)) * 1000000 + TOTAL_EXEC_TIME_MS) / NUM_EXECUTIONS, 
PREP_TIME_WORST, 
CASE WHEN TOTAL_EXEC_TIME = 0 AND TOTAL_EXEC_TIME_MS = 0 
THEN 100.00 
ELSE DEC( ( DOUBLE(PREP_TIME_WORST * 1000) / 
DOUBLE(TOTAL_EXEC_TIME * 1000000 + TOTAL_EXEC_TIME_MS) 
) * 100, 8, 2 ) 
END, 
STMT_TEXT, DBPARTITIONNUM, MEMBER 
FROM SYSIBMADM.SNAPDYN_SQL 
WHERE NUM_EXECUTIONS > 0 

;

-- View: SYSIBMADM.REG_VARIABLES
CREATE VIEW SYSIBMADM.REG_VARIABLES AS CREATE OR REPLACE VIEW SYSIBMADM.REG_VARIABLES 
(dbpartitionnum, reg_var_name, reg_var_value, is_aggregate, 
aggregate_name, level ) 
AS SELECT 
dbpartitionnum, reg_var_name, reg_var_value, is_aggregate, 
aggregate_name, level 
FROM TABLE(SYSPROC.REG_LIST_VARIABLES()) as t 

;

-- View: SYSIBMADM.SNAPAGENT
CREATE VIEW SYSIBMADM.SNAPAGENT AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPAGENT 
(snapshot_timestamp, db_name, agent_id, agent_pid, lock_timeout_val, dbpartitionnum, member) 
AS SELECT 
snapshot_timestamp, db_name, agent_id, agent_pid, lock_timeout_val, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_AGENT(' ')) as T 

;

-- View: SYSIBMADM.SNAPAGENT_MEMORY_POOL
CREATE VIEW SYSIBMADM.SNAPAGENT_MEMORY_POOL AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPAGENT_MEMORY_POOL 
(snapshot_timestamp, db_name, agent_id, agent_pid, pool_id, 
pool_cur_size, pool_watermark, pool_config_size, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, db_name, agent_id, agent_pid, pool_id, 
pool_cur_size, pool_watermark, pool_config_size, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_AGENT_MEMORY_POOL(' ')) as T 

;

-- View: SYSIBMADM.SNAPAPPL
CREATE VIEW SYSIBMADM.SNAPAPPL AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPAPPL 
(snapshot_timestamp, db_name, agent_id, uow_log_space_used, rows_read, 
rows_written, inact_stmthist_sz, pool_data_l_reads, pool_data_p_reads, 
pool_data_writes, pool_index_l_reads, pool_index_p_reads, pool_index_writes, 
pool_temp_data_l_reads, pool_temp_data_p_reads, pool_temp_index_l_reads, 
pool_temp_index_p_reads, pool_temp_xda_l_reads, pool_temp_xda_p_reads, pool_xda_l_reads, 
pool_xda_p_reads, pool_xda_writes, pool_read_time, pool_write_time, direct_reads, 
direct_writes, direct_read_reqs, direct_write_reqs, direct_read_time, direct_write_time, 
unread_prefetch_pages, 
locks_held, lock_waits,  lock_wait_time,  lock_escals, x_lock_escals, 
deadlocks, total_sorts, total_sort_time, sort_overflows, commit_sql_stmts, 
rollback_sql_stmts, dynamic_sql_stmts, static_sql_stmts, failed_sql_stmts, 
select_sql_stmts, ddl_sql_stmts, uid_sql_stmts, int_auto_rebinds, int_rows_deleted, 
int_rows_updated, int_commits, int_rollbacks, int_deadlock_rollbacks, rows_deleted, 
rows_inserted, rows_updated, rows_selected, binds_precompiles, open_rem_curs, 
open_rem_curs_blk, rej_curs_blk, acc_curs_blk, sql_reqs_since_commit, lock_timeouts, 
int_rows_inserted, open_loc_curs, open_loc_curs_blk, pkg_cache_lookups, 
pkg_cache_inserts, cat_cache_lookups, cat_cache_inserts, cat_cache_overflows, num_agents, 
agents_stolen, associated_agents_top, appl_priority, appl_priority_type, prefetch_wait_time, 
appl_section_lookups, appl_section_inserts, locks_waiting, total_hash_joins, 
total_hash_loops, hash_join_overflows, hash_join_small_overflows, appl_idle_time, 
uow_lock_wait_time, uow_comp_status, agent_usr_cpu_time_s, agent_usr_cpu_time_ms, 
agent_sys_cpu_time_s, agent_sys_cpu_time_ms, appl_con_time, conn_complete_time, 
last_reset, uow_start_time, uow_stop_time, prev_uow_stop_time, uow_elapsed_time_s, 
uow_elapsed_time_ms, elapsed_exec_time_s, elapsed_exec_time_ms, inbound_comm_address, 
lock_timeout_val, priv_workspace_num_overflows, priv_workspace_section_inserts, 
priv_workspace_section_lookups, priv_workspace_size_top, shr_workspace_num_overflows, 
shr_workspace_section_inserts, shr_workspace_section_lookups, shr_workspace_size_top, 
dbpartitionnum, cat_cache_size_top, total_olap_funcs, olap_func_overflows, member ) 
AS SELECT 
snapshot_timestamp, db_name, agent_id, uow_log_space_used, rows_read, 
rows_written, inact_stmthist_sz, pool_data_l_reads, pool_data_p_reads, 
pool_data_writes, pool_index_l_reads, pool_index_p_reads, pool_index_writes, 
pool_temp_data_l_reads, pool_temp_data_p_reads, pool_temp_index_l_reads, 
pool_temp_index_p_reads, pool_temp_xda_l_reads, pool_temp_xda_p_reads, pool_xda_l_reads, 
pool_xda_p_reads, pool_xda_writes, pool_read_time, pool_write_time, direct_reads, 
direct_writes, direct_read_reqs, direct_write_reqs, direct_read_time, direct_write_time, 
unread_prefetch_pages, 
locks_held, lock_waits,  lock_wait_time,  lock_escals, x_lock_escals, 
deadlocks, total_sorts, total_sort_time, sort_overflows, commit_sql_stmts, 
rollback_sql_stmts, dynamic_sql_stmts, static_sql_stmts, failed_sql_stmts, 
select_sql_stmts, ddl_sql_stmts, uid_sql_stmts, int_auto_rebinds, int_rows_deleted, 
int_rows_updated, int_commits, int_rollbacks, int_deadlock_rollbacks, rows_deleted, 
rows_inserted, rows_updated, rows_selected, binds_precompiles, open_rem_curs, 
open_rem_curs_blk, rej_curs_blk, acc_curs_blk, sql_reqs_since_commit, lock_timeouts, 
int_rows_inserted, open_loc_curs, open_loc_curs_blk, pkg_cache_lookups, 
pkg_cache_inserts, cat_cache_lookups, cat_cache_inserts, cat_cache_overflows, num_agents, 
agents_stolen, associated_agents_top, appl_priority, appl_priority_type, prefetch_wait_time, 
appl_section_lookups, appl_section_inserts, locks_waiting, total_hash_joins, 
total_hash_loops, hash_join_overflows, hash_join_small_overflows, appl_idle_time, 
uow_lock_wait_time, uow_comp_status, agent_usr_cpu_time_s, agent_usr_cpu_time_ms, 
agent_sys_cpu_time_s, agent_sys_cpu_time_ms, appl_con_time, conn_complete_time, 
last_reset, uow_start_time, uow_stop_time, prev_uow_stop_time, uow_elapsed_time_s, 
uow_elapsed_time_ms, elapsed_exec_time_s, elapsed_exec_time_ms, inbound_comm_address, 
lock_timeout_val, priv_workspace_num_overflows, priv_workspace_section_inserts, 
priv_workspace_section_lookups, priv_workspace_size_top, shr_workspace_num_overflows, 
shr_workspace_section_inserts, shr_workspace_section_lookups, shr_workspace_size_top, 
dbpartitionnum, cat_cache_size_top, total_olap_funcs, olap_func_overflows, member 
FROM TABLE(SYSPROC.SNAP_GET_APPL(' ')) as T 

;

-- View: SYSIBMADM.SNAPAPPL_INFO
CREATE VIEW SYSIBMADM.SNAPAPPL_INFO AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPAPPL_INFO 
(snapshot_timestamp, agent_id, appl_status, codepage_id, num_assoc_agents, 
coord_node_num, authority_lvl, client_pid, coord_agent_pid,status_change_time, 
client_platform, client_protocol, territory_code, appl_name, appl_id, sequence_no, 
primary_auth_id, session_auth_id, client_nname, client_prdid, input_db_alias, 
client_db_alias, db_name, db_path, execution_id, corr_token, tpmon_client_userid, 
tpmon_client_wkstn, tpmon_client_app, tpmon_acc_str, dbpartitionnum, workload_id, is_system_appl, member, coord_member, coord_dbpartitionnum) 
AS SELECT 
snapshot_timestamp, agent_id, appl_status, codepage_id, num_assoc_agents, 
coord_node_num, authority_lvl, client_pid, coord_agent_pid,status_change_time, 
client_platform, client_protocol, territory_code, appl_name, appl_id, sequence_no, 
primary_auth_id, session_auth_id, client_nname, client_prdid, input_db_alias, 
client_db_alias, db_name, db_path, execution_id, corr_token, tpmon_client_userid, 
tpmon_client_wkstn, tpmon_client_app, tpmon_acc_str, dbpartitionnum, workload_id, is_system_appl, member, coord_member, coord_dbpartitionnum 
FROM TABLE(SYSPROC.SNAP_GET_APPL_INFO(' ')) as T 

;

-- View: SYSIBMADM.SNAPBP
CREATE VIEW SYSIBMADM.SNAPBP AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPBP 
(snapshot_timestamp, bp_name, db_name, db_path, input_db_alias, pool_data_l_reads, 
pool_data_p_reads, pool_data_writes, pool_index_l_reads, pool_index_p_reads, 
pool_index_writes, pool_xda_l_reads, pool_xda_p_reads, pool_xda_writes, pool_read_time, 
pool_write_time, pool_async_data_reads, pool_async_data_writes, pool_async_index_reads, 
pool_async_index_writes, pool_async_xda_reads, pool_async_xda_writes, 
pool_async_read_time, pool_async_write_time, pool_async_data_read_reqs, 
pool_async_index_read_reqs, pool_async_xda_read_reqs, direct_reads, 
direct_writes, direct_read_reqs, direct_write_reqs, direct_read_time, 
direct_write_time, unread_prefetch_pages, 
files_closed, pool_temp_data_l_reads, pool_temp_data_p_reads, pool_temp_index_l_reads, 
pool_temp_index_p_reads, pool_temp_xda_l_reads, pool_temp_xda_p_reads, pool_no_victim_buffer, 
pages_from_block_ios, pages_from_vectored_ios, vectored_ios, 
dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, bp_name, db_name, db_path, input_db_alias, pool_data_l_reads, 
pool_data_p_reads, pool_data_writes, pool_index_l_reads, pool_index_p_reads, 
pool_index_writes, pool_xda_l_reads, pool_xda_p_reads, pool_xda_writes, pool_read_time, 
pool_write_time, pool_async_data_reads, pool_async_data_writes, pool_async_index_reads, 
pool_async_index_writes, pool_async_xda_reads, pool_async_xda_writes, 
pool_async_read_time, pool_async_write_time, pool_async_data_read_reqs, 
pool_async_index_read_reqs, pool_async_xda_read_reqs, direct_reads, 
direct_writes, direct_read_reqs, direct_write_reqs, direct_read_time, 
direct_write_time, unread_prefetch_pages, 
files_closed, pool_temp_data_l_reads, pool_temp_data_p_reads, pool_temp_index_l_reads, 
pool_temp_index_p_reads, pool_temp_xda_l_reads, pool_temp_xda_p_reads, pool_no_victim_buffer, 
pages_from_block_ios, pages_from_vectored_ios, vectored_ios, 
dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_BP(' ')) as T 

;

-- View: SYSIBMADM.SNAPBP_PART
CREATE VIEW SYSIBMADM.SNAPBP_PART AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPBP_PART 
(snapshot_timestamp, bp_name, db_name, bp_cur_buffsz, bp_new_buffsz, 
bp_pages_left_to_remove, bp_tbsp_use_count, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, bp_name, db_name, bp_cur_buffsz, bp_new_buffsz, 
bp_pages_left_to_remove, bp_tbsp_use_count, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_BP_PART(' ')) as T 

;

-- View: SYSIBMADM.SNAPCONTAINER
CREATE VIEW SYSIBMADM.SNAPCONTAINER AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPCONTAINER 
(SNAPSHOT_TIMESTAMP, TBSP_NAME, TBSP_ID, CONTAINER_NAME, CONTAINER_ID, CONTAINER_TYPE, 
TOTAL_PAGES, USABLE_PAGES, ACCESSIBLE, STRIPE_SET, DBPARTITIONNUM, FS_ID, 
FS_TOTAL_SIZE, FS_USED_SIZE ) 
AS SELECT 
SNAPSHOT_TIMESTAMP, TBSP_NAME, TBSP_ID, CONTAINER_NAME, CONTAINER_ID, CONTAINER_TYPE, 
TOTAL_PAGES, USABLE_PAGES, ACCESSIBLE, STRIPE_SET, DBPARTITIONNUM, FS_ID, 
FS_TOTAL_SIZE, FS_USED_SIZE 
FROM TABLE(SYSPROC.SNAP_GET_CONTAINER('')) as T 

;

-- View: SYSIBMADM.SNAPDB
CREATE VIEW SYSIBMADM.SNAPDB AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPDB 
( snapshot_timestamp, db_name, db_path, input_db_alias, db_status, catalog_partition, 
catalog_partition_name, server_platform, db_location, db_conn_time, last_reset, 
last_backup, connections_top, total_cons, total_sec_cons, appls_cur_cons, 
appls_in_db2, num_assoc_agents, agents_top, coord_agents_top, locks_held, lock_waits, 
lock_wait_time, lock_list_in_use, deadlocks, lock_escals, x_lock_escals, locks_waiting, 
lock_timeouts, num_indoubt_trans, sort_heap_allocated, sort_shrheap_allocated, 
sort_shrheap_top, post_shrthreshold_sorts, total_sorts, total_sort_time, sort_overflows, active_sorts, 
pool_data_l_reads, pool_data_p_reads, pool_temp_data_l_reads, pool_temp_data_p_reads, 
pool_async_data_reads, pool_data_writes, pool_async_data_writes, pool_index_l_reads, 
pool_index_p_reads, pool_temp_index_l_reads, pool_temp_index_p_reads, 
pool_async_index_reads, pool_index_writes, pool_async_index_writes, pool_xda_p_reads, 
pool_xda_l_reads, pool_xda_writes, pool_async_xda_reads, pool_async_xda_writes, 
pool_temp_xda_p_reads, pool_temp_xda_l_reads, pool_read_time, pool_write_time, 
pool_async_read_time, pool_async_write_time, pool_async_data_read_reqs, pool_async_index_read_reqs, 
pool_async_xda_read_reqs, pool_no_victim_buffer, pool_lsn_gap_clns, pool_drty_pg_steal_clns, 
pool_drty_pg_thrsh_clns, prefetch_wait_time, unread_prefetch_pages, direct_reads, direct_writes, 
direct_read_reqs, direct_write_reqs, direct_read_time, direct_write_time, files_closed, 
elapsed_exec_time_s, elapsed_exec_time_ms, 
commit_sql_stmts, rollback_sql_stmts, dynamic_sql_stmts, static_sql_stmts, failed_sql_stmts, 
select_sql_stmts, uid_sql_stmts, ddl_sql_stmts, int_auto_rebinds, int_rows_deleted, 
int_rows_inserted, int_rows_updated, int_commits, int_rollbacks, int_deadlock_rollbacks, 
rows_deleted, rows_inserted, rows_updated, rows_selected, rows_read, binds_precompiles, 
total_log_available, total_log_used, sec_log_used_top, tot_log_used_top, sec_logs_allocated, 
log_reads, log_read_time_s, log_read_time_ns, log_writes, log_write_time_s, log_write_time_ns, 
num_log_write_io, num_log_read_io, num_log_part_page_io, num_log_buffer_full, 
num_log_data_found_in_buffer, appl_id_oldest_xact, log_to_redo_for_recovery, 
log_held_by_dirty_pages, pkg_cache_lookups, pkg_cache_inserts, pkg_cache_num_overflows, 
pkg_cache_size_top, appl_section_lookups, appl_section_inserts, cat_cache_lookups, 
cat_cache_inserts, cat_cache_overflows, cat_cache_size_top, priv_workspace_size_top, 
priv_workspace_num_overflows, priv_workspace_section_inserts, priv_workspace_section_lookups, 
shr_workspace_size_top, shr_workspace_num_overflows, shr_workspace_section_inserts, 
shr_workspace_section_lookups, total_hash_joins, total_hash_loops, hash_join_overflows, 
hash_join_small_overflows, post_shrthreshold_hash_joins, active_hash_joins, num_db_storage_paths, 
dbpartitionnum, smallest_log_avail_node, total_olap_funcs, olap_func_overflows, 
active_olap_funcs, stats_cache_size, stats_fabrications, sync_runstats, async_runstats, 
stats_fabricate_time, sync_runstats_time, num_threshold_violations, member) 
AS SELECT 
snapshot_timestamp, db_name, db_path, input_db_alias, db_status, catalog_partition, 
catalog_partition_name, server_platform, db_location, db_conn_time, last_reset, 
last_backup, connections_top, total_cons, total_sec_cons, appls_cur_cons, 
appls_in_db2, num_assoc_agents, agents_top, coord_agents_top, locks_held, lock_waits, 
lock_wait_time, lock_list_in_use, deadlocks, lock_escals, x_lock_escals, locks_waiting, 
lock_timeouts, num_indoubt_trans, sort_heap_allocated, sort_shrheap_allocated, 
sort_shrheap_top, post_shrthreshold_sorts, total_sorts, total_sort_time, sort_overflows, active_sorts, 
pool_data_l_reads, pool_data_p_reads, pool_temp_data_l_reads, pool_temp_data_p_reads, 
pool_async_data_reads, pool_data_writes, pool_async_data_writes, pool_index_l_reads, 
pool_index_p_reads, pool_temp_index_l_reads, pool_temp_index_p_reads, 
pool_async_index_reads, pool_index_writes, pool_async_index_writes, pool_xda_p_reads, 
pool_xda_l_reads, pool_xda_writes, pool_async_xda_reads, pool_async_xda_writes, 
pool_temp_xda_p_reads, pool_temp_xda_l_reads, pool_read_time, pool_write_time, 
pool_async_read_time, pool_async_write_time, pool_async_data_read_reqs, pool_async_index_read_reqs, 
pool_async_xda_read_reqs, pool_no_victim_buffer, pool_lsn_gap_clns, pool_drty_pg_steal_clns, 
pool_drty_pg_thrsh_clns, prefetch_wait_time, unread_prefetch_pages, direct_reads, direct_writes, 
direct_read_reqs, direct_write_reqs, direct_read_time, direct_write_time, files_closed, 
elapsed_exec_time_s, elapsed_exec_time_ms, 
commit_sql_stmts, rollback_sql_stmts, dynamic_sql_stmts, static_sql_stmts, failed_sql_stmts, 
select_sql_stmts, uid_sql_stmts, ddl_sql_stmts, int_auto_rebinds, int_rows_deleted, 
int_rows_inserted, int_rows_updated, int_commits, int_rollbacks, int_deadlock_rollbacks, 
rows_deleted, rows_inserted, rows_updated, rows_selected, rows_read, binds_precompiles, 
total_log_available, total_log_used, sec_log_used_top, tot_log_used_top, sec_logs_allocated, 
log_reads, log_read_time_s, log_read_time_ns, log_writes, log_write_time_s, log_write_time_ns, 
num_log_write_io, num_log_read_io, num_log_part_page_io, num_log_buffer_full, 
num_log_data_found_in_buffer, appl_id_oldest_xact, log_to_redo_for_recovery, 
log_held_by_dirty_pages, pkg_cache_lookups, pkg_cache_inserts, pkg_cache_num_overflows, 
pkg_cache_size_top, appl_section_lookups, appl_section_inserts, cat_cache_lookups, 
cat_cache_inserts, cat_cache_overflows, cat_cache_size_top, priv_workspace_size_top, 
priv_workspace_num_overflows, priv_workspace_section_inserts, priv_workspace_section_lookups, 
shr_workspace_size_top, shr_workspace_num_overflows, shr_workspace_section_inserts, 
shr_workspace_section_lookups, total_hash_joins, total_hash_loops, hash_join_overflows, 
hash_join_small_overflows, post_shrthreshold_hash_joins, active_hash_joins, num_db_storage_paths, 
dbpartitionnum, smallest_log_avail_node, total_olap_funcs, olap_func_overflows, active_olap_funcs, 
stats_cache_size, stats_fabrications, sync_runstats, async_runstats, stats_fabricate_time, sync_runstats_time, 
num_threshold_violations, member 
FROM TABLE(SYSPROC.SNAP_GET_DB(' ')) as dbsnap 

;

-- View: SYSIBMADM.SNAPDBM
CREATE VIEW SYSIBMADM.SNAPDBM AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPDBM 
(snapshot_timestamp, sort_heap_allocated, post_threshold_sorts, piped_sorts_requested, 
piped_sorts_accepted, rem_cons_in, rem_cons_in_exec, local_cons, local_cons_in_exec, 
con_local_dbases, agents_registered, agents_waiting_on_token, db2_status, 
agents_registered_top, agents_waiting_top, comm_private_mem, idle_agents, 
agents_from_pool, agents_created_empty_pool, coord_agents_top, max_agent_overflows, 
agents_stolen, gw_total_cons, gw_cur_cons, gw_cons_wait_host, gw_cons_wait_client, 
post_threshold_hash_joins, num_gw_conn_switches, db2start_time, last_reset, 
num_nodes_in_db2_instance, product_name, service_level, sort_heap_top, 
dbpartitionnum, post_threshold_olap_funcs, member ) 
AS SELECT 
snapshot_timestamp, sort_heap_allocated, post_threshold_sorts, piped_sorts_requested, 
piped_sorts_accepted, rem_cons_in, rem_cons_in_exec, local_cons, local_cons_in_exec, 
con_local_dbases, agents_registered, agents_waiting_on_token, db2_status, 
agents_registered_top, agents_waiting_top, comm_private_mem, idle_agents, 
agents_from_pool, agents_created_empty_pool, coord_agents_top, max_agent_overflows, 
agents_stolen, gw_total_cons, gw_cur_cons, gw_cons_wait_host, gw_cons_wait_client, 
post_threshold_hash_joins, num_gw_conn_switches, db2start_time, last_reset, 
num_nodes_in_db2_instance, product_name, service_level, sort_heap_top, 
dbpartitionnum, post_threshold_olap_funcs, member 
FROM TABLE(SYSPROC.SNAP_GET_DBM()) as T 

;

-- View: SYSIBMADM.SNAPDBM_MEMORY_POOL
CREATE VIEW SYSIBMADM.SNAPDBM_MEMORY_POOL AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPDBM_MEMORY_POOL 
(snapshot_timestamp, pool_id, pool_cur_size, 
pool_watermark, pool_config_size, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, pool_id, pool_cur_size, 
pool_watermark, pool_config_size, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_DBM_MEMORY_POOL()) as T 

;

-- View: SYSIBMADM.SNAPDB_MEMORY_POOL
CREATE VIEW SYSIBMADM.SNAPDB_MEMORY_POOL AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPDB_MEMORY_POOL 
(snapshot_timestamp, db_name, pool_id, pool_secondary_id, 
pool_cur_size, pool_watermark, pool_config_size, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, db_name, pool_id, pool_secondary_id, 
pool_cur_size, pool_watermark, pool_config_size, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_DB_MEMORY_POOL(' ')) as T 

;

-- View: SYSIBMADM.SNAPDETAILLOG
CREATE VIEW SYSIBMADM.SNAPDETAILLOG AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPDETAILLOG 
(snapshot_timestamp, db_name, first_active_log, last_active_log, 
current_active_log, current_archive_log, dbpartitionnum, member) 
AS SELECT 
snapshot_timestamp, db_name, first_active_log, last_active_log, 
current_active_log, current_archive_log, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_DETAILLOG (' ')) as t 

;

-- View: SYSIBMADM.SNAPDYN_SQL
CREATE VIEW SYSIBMADM.SNAPDYN_SQL AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPDYN_SQL 
(snapshot_timestamp, num_executions, num_compilations, prep_time_worst, 
prep_time_best, int_rows_deleted, int_rows_inserted, int_rows_updated, 
rows_read, rows_written, stmt_sorts, sort_overflows, total_sort_time, 
pool_data_l_reads, pool_data_p_reads, pool_temp_data_l_reads, 
pool_temp_data_p_reads, pool_index_l_reads, pool_index_p_reads, 
pool_temp_index_l_reads, pool_temp_index_p_reads, pool_xda_l_reads, 
pool_xda_p_reads, pool_temp_xda_l_reads, pool_temp_xda_p_reads, 
total_exec_time, total_exec_time_ms, total_usr_cpu_time, 
total_usr_cpu_time_ms, total_sys_cpu_time, total_sys_cpu_time_ms, 
stmt_text, dbpartitionnum, stats_fabricate_time, sync_runstats_time, member ) 
AS SELECT 
snapshot_timestamp, num_executions, num_compilations, prep_time_worst, 
prep_time_best, int_rows_deleted, int_rows_inserted, int_rows_updated, 
rows_read, rows_written, stmt_sorts, sort_overflows, total_sort_time, 
pool_data_l_reads, pool_data_p_reads, pool_temp_data_l_reads, 
pool_temp_data_p_reads, pool_index_l_reads, pool_index_p_reads, 
pool_temp_index_l_reads, pool_temp_index_p_reads, pool_xda_l_reads, 
pool_xda_p_reads, pool_temp_xda_l_reads, pool_temp_xda_p_reads, 
total_exec_time, total_exec_time_ms, total_usr_cpu_time, 
total_usr_cpu_time_ms, total_sys_cpu_time, total_sys_cpu_time_ms, 
stmt_text, dbpartitionnum, stats_fabricate_time, sync_runstats_time, member 
FROM TABLE(SYSPROC.SNAP_GET_DYN_SQL ('')) as t 

;

-- View: SYSIBMADM.SNAPFCM
CREATE VIEW SYSIBMADM.SNAPFCM AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPFCM 
(snapshot_timestamp, buff_free, buff_free_bottom, ch_free, 
ch_free_bottom, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, buff_free, buff_free_bottom, ch_free, 
ch_free_bottom, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_FCM()) as T 

;

-- View: SYSIBMADM.SNAPFCM_PART
CREATE VIEW SYSIBMADM.SNAPFCM_PART AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPFCM_PART 
(snapshot_timestamp, connection_status, total_buffers_sent, 
total_buffers_rcvd, dbpartitionnum, fcm_dbpartitionnum, member, fcm_member ) 
AS SELECT 
snapshot_timestamp, connection_status, total_buffers_sent, 
total_buffers_rcvd, dbpartitionnum, fcm_dbpartitionnum, member, fcm_member 
FROM TABLE(SYSPROC.SNAP_GET_FCM_PART()) as T 

;

-- View: SYSIBMADM.SNAPHADR
CREATE VIEW SYSIBMADM.SNAPHADR AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPHADR 
(snapshot_timestamp, db_name, hadr_role, hadr_state, hadr_syncmode, 
hadr_connect_status, hadr_connect_time, hadr_heartbeat, hadr_local_host, 
hadr_local_service, hadr_remote_host, hadr_remote_service, 
hadr_remote_instance, hadr_timeout, hadr_primary_log_file, 
hadr_primary_log_page, hadr_primary_log_lsn, hadr_standby_log_file, 
hadr_standby_log_page, hadr_standby_log_lsn, hadr_log_gap, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, db_name, hadr_role, hadr_state, hadr_syncmode, 
hadr_connect_status, hadr_connect_time, hadr_heartbeat, hadr_local_host, 
hadr_local_service, hadr_remote_host, hadr_remote_service, 
hadr_remote_instance, hadr_timeout, hadr_primary_log_file, 
hadr_primary_log_page, hadr_primary_log_lsn, hadr_standby_log_file, 
hadr_standby_log_page, hadr_standby_log_lsn, hadr_log_gap, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_HADR (' ')) as t 

;

-- View: SYSIBMADM.SNAPLOCK
CREATE VIEW SYSIBMADM.SNAPLOCK AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPLOCK 
(snapshot_timestamp, agent_id, tab_file_id, lock_object_type, lock_mode, 
lock_status, lock_escalation, tabname, tabschema, tbsp_name, 
lock_attributes, lock_count, lock_current_mode, lock_hold_count, lock_name, 
lock_release_flags, data_partition_id, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, agent_id, tab_file_id, lock_object_type, lock_mode, 
lock_status, lock_escalation, tabname, tabschema, tbsp_name, 
lock_attributes, lock_count, lock_current_mode, lock_hold_count, lock_name, 
lock_release_flags, data_partition_id, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_LOCK ('')) as t 

;

-- View: SYSIBMADM.SNAPLOCKWAIT
CREATE VIEW SYSIBMADM.SNAPLOCKWAIT AS CREATE  OR REPLACE VIEW SYSIBMADM.SNAPLOCKWAIT 
(snapshot_timestamp, agent_id, subsection_number, lock_mode, 
lock_object_type, agent_id_holding_lk, lock_wait_start_time, 
lock_mode_requested, lock_escalation, tabname, tabschema, tbsp_name, 
appl_id_holding_lk, lock_attributes, lock_current_mode, lock_name, 
lock_release_flags, data_partition_id, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, agent_id, subsection_number, lock_mode, 
lock_object_type, agent_id_holding_lk, lock_wait_start_time, 
lock_mode_requested, lock_escalation, tabname, tabschema, tbsp_name, 
appl_id_holding_lk, lock_attributes, lock_current_mode, lock_name, 
lock_release_flags, data_partition_id, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_LOCKWAIT ('')) as t 

;

-- View: SYSIBMADM.SNAPSTMT
CREATE VIEW SYSIBMADM.SNAPSTMT AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPSTMT 
(snapshot_timestamp, db_name, agent_id, rows_read, rows_written, num_agents, 
agents_top, stmt_type, stmt_operation, section_number, query_cost_estimate, 
query_card_estimate, degree_parallelism, stmt_sorts, total_sort_time, 
sort_overflows, int_rows_deleted, int_rows_updated, int_rows_inserted, 
fetch_count, stmt_start, stmt_stop, stmt_usr_cpu_time_s, stmt_usr_cpu_time_ms, 
stmt_sys_cpu_time_s, stmt_sys_cpu_time_ms, stmt_elapsed_time_s, 
stmt_elapsed_time_ms, blocking_cursor, stmt_node_number, cursor_name, creator, 
package_name, stmt_text, consistency_token, package_version_id, 
pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, 
pool_xda_l_reads, pool_xda_p_reads, pool_temp_data_l_reads, pool_temp_data_p_reads, 
pool_temp_index_l_reads, pool_temp_index_p_reads, pool_temp_xda_l_reads, 
pool_temp_xda_p_reads, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, db_name, agent_id, rows_read, rows_written, num_agents, 
agents_top, stmt_type, stmt_operation, section_number, query_cost_estimate, 
query_card_estimate, degree_parallelism, stmt_sorts, total_sort_time, 
sort_overflows, int_rows_deleted, int_rows_updated, int_rows_inserted, 
fetch_count, stmt_start, stmt_stop, stmt_usr_cpu_time_s, stmt_usr_cpu_time_ms, 
stmt_sys_cpu_time_s, stmt_sys_cpu_time_ms, stmt_elapsed_time_s, 
stmt_elapsed_time_ms, blocking_cursor, stmt_node_number, cursor_name, creator, 
package_name, stmt_text, consistency_token, package_version_id, 
pool_data_l_reads, pool_data_p_reads, pool_index_l_reads, pool_index_p_reads, 
pool_xda_l_reads, pool_xda_p_reads, pool_temp_data_l_reads, 
pool_temp_data_p_reads, pool_temp_index_l_reads, pool_temp_index_p_reads, 
pool_temp_xda_l_reads, pool_temp_xda_p_reads, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_STMT (' ')) as t 

;

-- View: SYSIBMADM.SNAPSTORAGE_PATHS
CREATE VIEW SYSIBMADM.SNAPSTORAGE_PATHS AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPSTORAGE_PATHS 
(snapshot_timestamp, db_name, db_storage_path, db_storage_path_with_dpe, 
dbpartitionnum, db_storage_path_state, fs_id, fs_total_size, fs_used_size, 
sto_path_free_size) 
AS SELECT 
snapshot_timestamp, db_name, db_storage_path, db_storage_path_with_dpe, 
dbpartitionnum, db_storage_path_state, fs_id, fs_total_size, fs_used_size, 
sto_path_free_size 
FROM TABLE(SYSPROC.SNAP_GET_STORAGE_PATHS (' ')) as t 

;

-- View: SYSIBMADM.SNAPSUBSECTION
CREATE VIEW SYSIBMADM.SNAPSUBSECTION AS CREATE OR REPLACE VIEW  SYSIBMADM.SNAPSUBSECTION 
(snapshot_timestamp, db_name, stmt_text, ss_exec_time, tq_tot_send_spills, 
tq_cur_send_spills, tq_max_send_spills, tq_rows_read, tq_rows_written, 
rows_read, rows_written, ss_usr_cpu_time_s, ss_usr_cpu_time_ms, ss_sys_cpu_time_s, 
ss_sys_cpu_time_ms, ss_number, ss_status, ss_node_number, tq_node_waited_for, 
tq_wait_for_any, tq_id_waiting_on, dbpartitionnum, member) 
AS SELECT 
snapshot_timestamp, db_name, stmt_text, ss_exec_time, tq_tot_send_spills, 
tq_cur_send_spills, tq_max_send_spills, tq_rows_read, tq_rows_written, 
rows_read, rows_written, ss_usr_cpu_time_s, ss_usr_cpu_time_ms, ss_sys_cpu_time_s, 
ss_sys_cpu_time_ms, ss_number, ss_status, ss_node_number, tq_node_waited_for, 
tq_wait_for_any, tq_id_waiting_on, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_SUBSECTION (' ')) as t 

;

-- View: SYSIBMADM.SNAPSWITCHES
CREATE VIEW SYSIBMADM.SNAPSWITCHES AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPSWITCHES 
(snapshot_timestamp, uow_sw_state, uow_sw_time, statement_sw_state, 
statement_sw_time, table_sw_state, table_sw_time, buffpool_sw_state, 
buffpool_sw_time, lock_sw_state, lock_sw_time, sort_sw_state, sort_sw_time, 
timestamp_sw_state, timestamp_sw_time, dbpartitionnum, member) 
AS SELECT 
snapshot_timestamp, uow_sw_state, uow_sw_time, statement_sw_state, 
statement_sw_time, table_sw_state, table_sw_time, buffpool_sw_state, 
buffpool_sw_time, lock_sw_state, lock_sw_time, sort_sw_state, sort_sw_time, 
timestamp_sw_state, timestamp_sw_time, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_SWITCHES()) as t 

;

-- View: SYSIBMADM.SNAPTAB
CREATE VIEW SYSIBMADM.SNAPTAB AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPTAB 
(snapshot_timestamp, tabschema, tabname, tab_file_id, tab_type, 
data_object_pages, index_object_pages, lob_object_pages, long_object_pages, 
xda_object_pages, rows_read, rows_written, overflow_accesses, page_reorgs, 
dbpartitionnum, tbsp_id, data_partition_id, member ) 
AS SELECT 
snapshot_timestamp, tabschema, tabname, tab_file_id, tab_type, 
data_object_pages, index_object_pages, lob_object_pages, long_object_pages, 
xda_object_pages, rows_read, rows_written, overflow_accesses, page_reorgs, 
dbpartitionnum, tbsp_id, data_partition_id, member 
FROM TABLE(SYSPROC.SNAP_GET_TAB('')) as t 

;

-- View: SYSIBMADM.SNAPTAB_REORG
CREATE VIEW SYSIBMADM.SNAPTAB_REORG AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPTAB_REORG 
(snapshot_timestamp, tabname, tabschema, page_reorgs, reorg_phase, 
reorg_max_phase, reorg_current_counter, reorg_max_counter, reorg_type, reorg_status, 
reorg_completion, reorg_start, reorg_end, reorg_phase_start, reorg_index_id, 
reorg_tbspc_id, dbpartitionnum, data_partition_id, reorg_rowscompressed, 
reorg_rowsrejected, reorg_long_tbspc_id, member) 
AS SELECT 
snapshot_timestamp, tabname, tabschema, page_reorgs, reorg_phase, 
reorg_max_phase, reorg_current_counter, reorg_max_counter, reorg_type, reorg_status, 
reorg_completion, reorg_start, reorg_end, reorg_phase_start, reorg_index_id, 
reorg_tbspc_id, dbpartitionnum, data_partition_id, reorg_rowscompressed, 
reorg_rowsrejected, reorg_long_tbspc_id, member 
FROM TABLE(SYSPROC.SNAP_GET_TAB_REORG('')) as t 

;

-- View: SYSIBMADM.SNAPTBSP
CREATE VIEW SYSIBMADM.SNAPTBSP AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPTBSP 
(snapshot_timestamp, tbsp_name, tbsp_id, tbsp_type, tbsp_content_type, 
tbsp_page_size, tbsp_extent_size, tbsp_prefetch_size, tbsp_cur_pool_id, 
tbsp_next_pool_id, fs_caching, pool_data_l_reads, pool_data_p_reads, 
pool_temp_data_l_reads, pool_temp_data_p_reads, pool_async_data_reads, 
pool_data_writes, pool_async_data_writes, pool_index_l_reads, 
pool_index_p_reads, pool_temp_index_l_reads, pool_temp_index_p_reads, 
pool_async_index_reads, pool_index_writes, pool_async_index_writes, 
pool_xda_l_reads, pool_xda_p_reads, pool_xda_writes, pool_async_xda_reads, 
pool_async_xda_writes, pool_temp_xda_l_reads, pool_temp_xda_p_reads, 
pool_read_time, pool_write_time, pool_async_read_time, pool_async_write_time, 
pool_async_data_read_reqs, pool_async_index_read_reqs, pool_async_xda_read_reqs, 
pool_no_victim_buffer, direct_reads, direct_writes, direct_read_reqs, direct_write_reqs, 
direct_read_time, direct_write_time, files_closed, unread_prefetch_pages, 
tbsp_rebalancer_mode, tbsp_using_auto_storage, tbsp_auto_resize_enabled, 
dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, tbsp_name, tbsp_id, tbsp_type, tbsp_content_type, 
tbsp_page_size, tbsp_extent_size, tbsp_prefetch_size, tbsp_cur_pool_id, 
tbsp_next_pool_id, fs_caching, pool_data_l_reads, pool_data_p_reads, 
pool_temp_data_l_reads, pool_temp_data_p_reads, pool_async_data_reads, 
pool_data_writes, pool_async_data_writes, pool_index_l_reads, 
pool_index_p_reads, pool_temp_index_l_reads, pool_temp_index_p_reads, 
pool_async_index_reads, pool_index_writes, pool_async_index_writes, 
pool_xda_l_reads, pool_xda_p_reads, pool_xda_writes, pool_async_xda_reads, 
pool_async_xda_writes, pool_temp_xda_l_reads, pool_temp_xda_p_reads, 
pool_read_time, pool_write_time, pool_async_read_time, pool_async_write_time, 
pool_async_data_read_reqs, pool_async_index_read_reqs, pool_async_xda_read_reqs, 
pool_no_victim_buffer, direct_reads, direct_writes, direct_read_reqs, direct_write_reqs, 
direct_read_time, direct_write_time, files_closed, unread_prefetch_pages, 
tbsp_rebalancer_mode, tbsp_using_auto_storage, tbsp_auto_resize_enabled, 
dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_TBSP('')) as t 

;

-- View: SYSIBMADM.SNAPTBSP_PART
CREATE VIEW SYSIBMADM.SNAPTBSP_PART AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPTBSP_PART 
(snapshot_timestamp, tbsp_name, tbsp_id, tbsp_state, tbsp_prefetch_size, 
tbsp_num_quiescers, tbsp_state_change_object_id, tbsp_state_change_tbsp_id, 
tbsp_min_recovery_time, tbsp_total_pages, tbsp_usable_pages, tbsp_used_pages, 
tbsp_free_pages, tbsp_pending_free_pages, tbsp_page_top, rebalancer_mode, 
rebalancer_extents_remaining, rebalancer_extents_processed, rebalancer_priority, 
rebalancer_start_time, rebalancer_restart_time, rebalancer_last_extent_moved, 
tbsp_num_ranges, tbsp_num_containers, tbsp_initial_size, tbsp_current_size, 
tbsp_max_size, tbsp_increase_size, tbsp_increase_size_percent, 
tbsp_last_resize_time, tbsp_last_resize_failed, dbpartitionnum, 
tbsp_paths_dropped) 
AS SELECT 
snapshot_timestamp, tbsp_name, tbsp_id, tbsp_state, tbsp_prefetch_size, 
tbsp_num_quiescers, tbsp_state_change_object_id, tbsp_state_change_tbsp_id, 
tbsp_min_recovery_time, tbsp_total_pages, tbsp_usable_pages, tbsp_used_pages, 
tbsp_free_pages, tbsp_pending_free_pages, tbsp_page_top, rebalancer_mode, 
rebalancer_extents_remaining, rebalancer_extents_processed, rebalancer_priority, 
rebalancer_start_time, rebalancer_restart_time, rebalancer_last_extent_moved, 
tbsp_num_ranges, tbsp_num_containers, tbsp_initial_size, tbsp_current_size, 
tbsp_max_size, tbsp_increase_size, tbsp_increase_size_percent, 
tbsp_last_resize_time, tbsp_last_resize_failed, dbpartitionnum, 
tbsp_paths_dropped 
FROM TABLE(SYSPROC.SNAP_GET_TBSP_PART('')) as t 

;

-- View: SYSIBMADM.SNAPTBSP_QUIESCER
CREATE VIEW SYSIBMADM.SNAPTBSP_QUIESCER AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPTBSP_QUIESCER 
(snapshot_timestamp, tbsp_name, quiescer_ts_id, quiescer_obj_id, 
quiescer_auth_id, quiescer_agent_id, quiescer_state, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, tbsp_name, quiescer_ts_id, quiescer_obj_id, 
quiescer_auth_id, quiescer_agent_id, quiescer_state, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_TBSP_QUIESCER('')) as t 

;

-- View: SYSIBMADM.SNAPTBSP_RANGE
CREATE VIEW SYSIBMADM.SNAPTBSP_RANGE AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPTBSP_RANGE 
(snapshot_timestamp, tbsp_id, tbsp_name, range_number, range_stripe_set_number, 
range_offset, range_max_page, range_max_extent, range_start_stripe, 
range_end_stripe, range_adjustment, range_num_container, range_container_id, 
dbpartitionnum ) 
AS SELECT 
snapshot_timestamp, tbsp_id, tbsp_name, range_number, range_stripe_set_number, 
range_offset, range_max_page, range_max_extent, range_start_stripe, 
range_end_stripe, range_adjustment, range_num_container, range_container_id, 
dbpartitionnum 
FROM TABLE(SYSPROC.SNAP_GET_TBSP_RANGE('')) as t 

;

-- View: SYSIBMADM.SNAPUTIL
CREATE VIEW SYSIBMADM.SNAPUTIL AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPUTIL 
(snapshot_timestamp, utility_id, utility_type, utility_priority, 
utility_description, utility_dbname, utility_start_time, 
utility_state, utility_invoker_type, dbpartitionnum, 
progress_list_attr, progress_list_cur_seq_num, member ) 
AS SELECT 
snapshot_timestamp, utility_id, utility_type, utility_priority, 
utility_description, utility_dbname, utility_start_time, 
utility_state, utility_invoker_type, dbpartitionnum, 
progress_list_attr, progress_list_cur_seq_num, member 
FROM TABLE(SYSPROC.SNAP_GET_UTIL()) as t 

;

-- View: SYSIBMADM.SNAPUTIL_PROGRESS
CREATE VIEW SYSIBMADM.SNAPUTIL_PROGRESS AS CREATE OR REPLACE VIEW SYSIBMADM.SNAPUTIL_PROGRESS 
(snapshot_timestamp, utility_id, progress_seq_num, utility_state, 
progress_description, progress_start_time, progress_work_metric, 
progress_total_units, progress_completed_units, dbpartitionnum, member ) 
AS SELECT 
snapshot_timestamp, utility_id, progress_seq_num, utility_state, 
progress_description, progress_start_time, progress_work_metric, 
progress_total_units, progress_completed_units, dbpartitionnum, member 
FROM TABLE(SYSPROC.SNAP_GET_UTIL_PROGRESS()) as t 

;

-- View: SYSIBMADM.TBSP_UTILIZATION
CREATE VIEW SYSIBMADM.TBSP_UTILIZATION AS CREATE OR REPLACE VIEW SYSIBMADM.TBSP_UTILIZATION 
( SNAPSHOT_TIMESTAMP, TBSP_ID, TBSP_NAME, TBSP_TYPE, TBSP_CONTENT_TYPE, 
TBSP_CREATE_TIME, TBSP_STATE, TBSP_TOTAL_SIZE_KB, TBSP_USABLE_SIZE_KB, 
TBSP_USED_SIZE_KB, TBSP_FREE_SIZE_KB, TBSP_UTILIZATION_PERCENT, TBSP_TOTAL_PAGES, 
TBSP_USABLE_PAGES, TBSP_USED_PAGES, TBSP_FREE_PAGES, TBSP_PAGE_TOP, TBSP_PAGE_SIZE, 
TBSP_EXTENT_SIZE, TBSP_PREFETCH_SIZE, TBSP_MAX_SIZE, TBSP_INCREASE_SIZE, 
TBSP_INCREASE_SIZE_PERCENT, TBSP_LAST_RESIZE_TIME, TBSP_LAST_RESIZE_FAILED, 
TBSP_USING_AUTO_STORAGE, TBSP_AUTO_RESIZE_ENABLED, DBPGNAME, TBSP_NUM_CONTAINERS, 
REMARKS, DBPARTITIONNUM) 
AS SELECT 
S.SNAPSHOT_TIMESTAMP, S.TBSP_ID, S.TBSP_NAME, P.TBSP_TYPE, P.TBSP_CONTENT_TYPE, 
T.CREATE_TIME, S.TBSP_STATE, (S.TBSP_TOTAL_PAGES*T.PAGESIZE)/1024, 
(S.TBSP_USABLE_PAGES*T.PAGESIZE)/1024, (S.TBSP_USED_PAGES*T.PAGESIZE)/1024, 
(S.TBSP_FREE_PAGES*T.PAGESIZE)/1024, 
CASE WHEN S.TBSP_USABLE_PAGES > 0 
THEN DEC(100* (FLOAT(S.TBSP_USED_PAGES)/FLOAT(S.TBSP_USABLE_PAGES)),5,2) 
ELSE DEC(-1,5,2) 
END, 
S.TBSP_TOTAL_PAGES, S.TBSP_USABLE_PAGES, S.TBSP_USED_PAGES, S.TBSP_FREE_PAGES, 
S.TBSP_PAGE_TOP, T.PAGESIZE, T.EXTENTSIZE, 
CASE WHEN P.TBSP_PREFETCH_SIZE < 0 
THEN S.TBSP_PREFETCH_SIZE 
ELSE P.TBSP_PREFETCH_SIZE 
END, 
S.TBSP_MAX_SIZE, S.TBSP_INCREASE_SIZE, S.TBSP_INCREASE_SIZE_PERCENT, S.TBSP_LAST_RESIZE_TIME, 
S.TBSP_LAST_RESIZE_FAILED, P.TBSP_USING_AUTO_STORAGE, P.TBSP_AUTO_RESIZE_ENABLED, 
T.DBPGNAME, S.TBSP_NUM_CONTAINERS, T.REMARKS, S.DBPARTITIONNUM 
FROM SYSIBMADM.SNAPTBSP_PART AS S, SYSIBMADM.SNAPTBSP AS P, SYSCAT.TABLESPACES T 
WHERE S.TBSP_ID = T.TBSPACEID and S.TBSP_ID = P.TBSP_ID AND S.DBPARTITIONNUM = P.DBPARTITIONNUM 

;

-- View: SYSIBMADM.TOP_DYNAMIC_SQL
CREATE VIEW SYSIBMADM.TOP_DYNAMIC_SQL AS CREATE OR REPLACE VIEW SYSIBMADM.TOP_DYNAMIC_SQL 
( SNAPSHOT_TIMESTAMP, NUM_EXECUTIONS, AVERAGE_EXECUTION_TIME_S, STMT_SORTS, 
SORTS_PER_EXECUTION, STMT_TEXT, DBPARTITIONNUM, MEMBER) 
AS SELECT 
SNAPSHOT_TIMESTAMP, NUM_EXECUTIONS, TOTAL_EXEC_TIME / NUM_EXECUTIONS, 
STMT_SORTS, STMT_SORTS / NUM_EXECUTIONS, STMT_TEXT, DBPARTITIONNUM, MEMBER 
FROM SYSIBMADM.SNAPDYN_SQL WHERE NUM_EXECUTIONS > 0 

;

-- Schema: SYSSTAT
CREATE SCHEMA SYSSTAT;

-- View: SYSSTAT.COLDIST
CREATE VIEW SYSSTAT.COLDIST AS create or replace view sysstat.coldist 
(tabschema, tabname, colname, type, seqno, colvalue, valcount, 
distcount) 
as select 
schema, tbname, name, type, seqno, colvalue, valcount, 
distcount 
from sysibm.syscoldist X 
where exists 
(select 1 from sysibm.systabauth 
where ttname = X.tbname 
and tcreator = X.schema 
and grantee = USER 
and granteetype = 'U' 
and controlauth = 'Y') 
or exists 
(select 1 from sysibm.sysdbauth 
where grantee = USER 
and granteetype = 'U' 
and dataaccessauth = 'Y') 
or exists 
(select 1 
from  sysibm.systabauth ta2, sysibm.sysviewdep vd 
where (select substr(Y.property,19,1) 
from   sysibm.systables y 
where  y.name = X.tbname 
and    y.creator = X.schema 
and    y.type='V')='Y' 
and    vd.btype IN ('T', 'U') 
and    vd.dname = X.tbname 
and    vd.dcreator = X.schema 
and    ta2.ttname = vd.bname 
and    ta2.tcreator = vd.bcreator 
and    ta2.controlauth = 'Y' 
and    (ta2.granteetype = 'U' 
and   ta2.grantee = USER) ) 

;

-- View: SYSSTAT.COLGROUPDIST
CREATE VIEW SYSSTAT.COLGROUPDIST AS create or replace view sysstat.colgroupdist 
(colgroupid, type, ordinal, seqno, colvalue) 
as select 
colgroupid, type, ordinal, seqno, colvalue 
from sysibm.syscolgroupdist 

;

-- View: SYSSTAT.COLGROUPDISTCOUNTS
CREATE VIEW SYSSTAT.COLGROUPDISTCOUNTS AS create or replace view sysstat.colgroupdistcounts 
(colgroupid, type, seqno, valcount, distcount) 
as select 
colgroupid, type, seqno, valcount, distcount 
from sysibm.syscolgroupdistcounts 

;

-- View: SYSSTAT.COLGROUPS
CREATE VIEW SYSSTAT.COLGROUPS AS create or replace view sysstat.colgroups 
(colgroupschema, colgroupname, colgroupid, colgroupcard, 
numfreq_values, numquantiles, numquantile) 
as select 
colgroupschema, colgroupname, colgroupid, colgroupcard, 
numfreq_values, numquantiles, numquantiles 
from sysibm.syscolgroups 

;

-- View: SYSSTAT.COLUMNS
CREATE VIEW SYSSTAT.COLUMNS AS create or replace view sysstat.columns 
(tabschema, tabname, colname, colcard, high2key, low2key, 
avgcollen, numnulls, pctinlined, sub_count, sub_delim_length, 
avgcollenchar, pctencoded, pagevarianceratio, avgencodedcollen) 
as select 
tbcreator, tbname, name, colcard, high2key, low2key, 
avgcollen, numnulls, pctinlined, sub_count, sub_delim_length, 
avgcollenchar, pctencoded, pagevarianceratio, avgencodedcollen 
from sysibm.syscolumns X 
where( (source_tabschema = tbcreator and 
source_tabname = tbname) or 
(source_tabschema IS NULL and 
source_tabname IS NULL) ) 
and exists 
(select 1 
from   sysibm.systables 
where  name = X.tbname 
and    creator = X.tbcreator 
and    (type not in ('A', 'V', 'W', 'H', 'K') or 
(type = 'V' and substr(property, 13, 1) = 'Y') ) ) 
and (exists 
(select 1 from   sysibm.systabauth 
where  ttname = X.tbname 
and    tcreator = X.tbcreator 
and    controlauth = 'Y' 
and   ( (granteetype = 'U' 
and      grantee = USER) 
or      (granteetype = 'G' 
and      grantee = 'PUBLIC')) 
or exists 
(select 1 from   sysibm.sysdbauth 
where  grantee = USER 
and    dataaccessauth = 'Y') 
or exists 
(select 1 
from   sysibm.systabauth ta2, sysibm.sysviewdep vd 
where  (select substr(Y.property,19,1) 
from   sysibm.systables y 
where  y.name = X.tbname 
and    y.creator = X.tbcreator 
and    y.type='V')='Y' 
and    vd.btype IN ('T', 'U') 
and    vd.dname = X.tbname 
and    vd.dcreator = X.tbcreator 
and    ta2.ttname = vd.bname 
and    ta2.tcreator = vd.bcreator 
and    ta2.controlauth = 'Y' 
and    ( (ta2.granteetype = 'U' 
and       ta2.grantee = USER) 
or       (ta2.granteetype = 'G' 
and       ta2.grantee = 'PUBLIC'))))) 

;

-- View: SYSSTAT.FUNCTIONS
CREATE VIEW SYSSTAT.FUNCTIONS AS create or replace view sysstat.functions 
(funcschema, funcname, specificname, ios_per_invoc, 
insts_per_invoc, ios_per_argbyte, insts_per_argbyte, 
percent_argbytes, initial_ios, initial_insts, 
cardinality, selectivity) 
as select 
routineschema, routinename, specificname, ios_per_invoc, 
insts_per_invoc, ios_per_argbyte, insts_per_argbyte, 
percent_argbytes, initial_ios, initial_insts, 
cardinality, selectivity 
from sysibm.sysroutines 
where 
routinemoduleid is null and 
( routinetype in ('F', 'M') and 
routineschema not in ('SYSIBMINTERNAL') and 
( routineschema = USER or 
EXISTS 
( select 1 
from sysibm.sysdbauth 
where grantee = USER and ( dbadmauth = 'Y' or sqladmauth ='Y' ) ) ) ) 

;

-- View: SYSSTAT.INDEXES
CREATE VIEW SYSSTAT.INDEXES AS create or replace view sysstat.indexes 
(indschema, indname, tabschema, tabname, colnames, nleaf, 
nlevels, firstkeycard, first2keycard, first3keycard, 
first4keycard, fullkeycard, clusterratio, clusterfactor, 
sequential_pages, density, page_fetch_pairs, 
numrids, numrids_deleted, num_empty_leafs, 
average_random_fetch_pages, average_random_pages, 
average_sequence_gap, average_sequence_fetch_gap, 
average_sequence_pages, average_sequence_fetch_pages, 
avgpartition_clusterratio, avgpartition_clusterfactor, 
avgpartition_page_fetch_pairs, 
datapartition_clusterfactor, indcard, pctpagessaved, 
avgleafkeysize, avgnleafkeysize) 
as select 
creator, name, tbcreator, tbname, colnames, nleaf, 
nlevels, firstkeycard, first2keycard, first3keycard, 
first4keycard, fullkeycard, clusterratio, clusterfactor, 
sequential_pages, density, page_fetch_pairs, 
numrids, numrids_deleted, num_empty_leafs, 
average_random_fetch_pages, average_random_pages, 
average_sequence_gap, average_sequence_fetch_gap, 
average_sequence_pages, average_sequence_fetch_pages, 
avgpartition_clusterratio, avgpartition_clusterfactor, 
avgpartition_page_fetch_pairs, 
datapartition_clusterfactor, indcard, pctpagessaved, 
avgleafkeysize, avgnleafkeysize 
from sysibm.sysindexes X 
where x.entrytype <> 'H' 
and x.indextype <> 'XVIL' 
and (exists 
(select 1 
from sysibm.sysindexauth 
where creator = X.creator 
and name = X.name 
and grantee = USER 
and controlauth = 'Y' ) 
or exists 
(select 1 
from sysibm.sysdbauth 
where  grantee = USER 
and dataaccessauth = 'Y') 
or exists 
(select 1 from sysibm.sysindexauth XA, sysibm.sysindexxmlpatterns XP 
where X.name = XP.pindname 
and XA.name = XP.indname 
and XA.creator = XP.indschema 
and XA.grantee = USER 
and XA.controlauth = 'Y') 
) 

;

-- View: SYSSTAT.ROUTINES
CREATE VIEW SYSSTAT.ROUTINES AS create or replace view sysstat.routines 
(routineschema, routinemodulename, routinename, routinetype, specificname, 
ios_per_invoc, insts_per_invoc, ios_per_argbyte, insts_per_argbyte, 
percent_argbytes, initial_ios, initial_insts, cardinality, selectivity) 
as select 
routineschema, 
(select modulename from sysibm.sysmodules where moduleid = routinemoduleid), 
routinename, routinetype, specificname, ios_per_invoc, 
insts_per_invoc, ios_per_argbyte, insts_per_argbyte, percent_argbytes, 
initial_ios, initial_insts, cardinality, selectivity 
from sysibm.sysroutines 
where 
routinemoduleid is null and 
(  routineschema = USER OR 
definer = USER OR 
routineschema not in ('SYSIBMINTERNAL') AND 
exists 
( 
select 1 
from sysibm.sysdbauth 
where grantee = USER and ( dbadmauth = 'Y' or sqladmauth = 'Y' ) 
) ) 

;

-- View: SYSSTAT.TABLES
CREATE VIEW SYSSTAT.TABLES AS create or replace view sysstat.tables 
(tabschema, tabname, card, npages, mpages, fpages, 
npartitions, nfiles, tablesize, 
overflow, 
clustered, active_blocks, avgcompressedrowsize, avgrowcompressionratio, 
avgrowsize, pctrowscompressed, pctpagessaved, pctextendedrows ) 
as with getroles(level,drolename) as 
(select 1, u.rolename 
from table (select a.rolename from sysibm.sysroleauth as a 
where a.granteetype='U' and a.grantee=USER 
union all 
select a.rolename from sysibm.sysroleauth as a 
where a.granteetype='G' and a.grantee='PUBLIC') as u 
union all 
select level+1, x.rolename 
from getroles, 
table(select a.rolename from sysibm.sysroleauth as a 
where a.grantee=getroles.drolename and 
a.granteetype='R') as x 
where level<1000000), 
getdistroles(rolename) as (select distinct drolename from getroles) 
select 
creator, name, card, npages, mpages, fpages, 
case 
when type = 'T' and substr(property,22,1) = 'Y' then mpages 
else -1 
end, 
case 
when type = 'T' and ((substr(property,22,1) = 'Y') or 
(substr(property,24,1) = 'Y')) then npages 
else -1 
end, 
case 
when type = 'T' and ((substr(property,22,1) = 'Y') or 
(substr(property,24,1) = 'Y')) then fpages 
else -1 
end, 
overflow, 
clustered, active_blocks, avgcompressedrowsize, avgrowcompressionratio, 
avgrowsize, pctrowscompressed, pctpagessaved, pctextendedrows 
from sysibm.systables X 
where (X.type not in ('A', 'V', 'W', 'H', 'K') 
or (X.type = 'V' and substr(X.property, 13, 1) = 'Y')) 
and (exists 
(select 1 
from   sysibm.systabauth ta 
where  ta.tcreator = X.creator 
and    ta.ttname = X.name 
and    ta.controlauth = 'Y' 
and    (   (ta.granteetype = 'U' 
and ta.grantee = USER) 
or (ta.granteetype = 'G' 
and ta.grantee = 'PUBLIC') 
or (ta.granteetype = 'R' 
and ta.grantee in (select r.rolename 
from getdistroles r )))) 
or exists 
(select 1 
from   sysibm.sysdbauth da 
where  da.dataaccessauth = 'Y' 
and    (  (da.grantee = USER 
and da.granteetype = 'U') 
or (da.granteetype = 'R' 
and da.grantee in (select r.rolename 
from getdistroles r )))) 
or exists 
(select 1 
from   sysibm.systabauth ta2, sysibm.sysviewdep vd 
where  (X.type='V' and substr(X.property,19,1)='Y') 
and    vd.btype IN ('T', 'U') 
and    vd.dname = X.name 
and    vd.dcreator = X.creator 
and    ta2.ttname = vd.bname 
and    ta2.tcreator = vd.bcreator 
and    ta2.controlauth = 'Y' 
and    (   (ta2.granteetype = 'U' 
and ta2.grantee = USER) 
or (ta2.granteetype = 'G' 
and ta2.grantee = 'PUBLIC') 
or (ta2.granteetype = 'R' 
and ta2.grantee in (select r.rolename 
from getdistroles r ))))) 

;

