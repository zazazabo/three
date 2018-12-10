
/*
 * 相当控制层，转发页面或返回json数据
 */
package com.mylib;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;

//import org.json.JSONArray;
//import org.json.JSONException;
public class ControlServlet extends HttpServlet {

    /**
     * 任何请求都会到这个servlet中，这个servlet就是充当MVC模式中的C（控制层）
     */
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Info info1 = new Info();
        info1.getinfo(request);
        if (info1.rtnype.equals("PGE")) {
            String url = dealpage(request, response, info1);
            request.getRequestDispatcher(url).forward(request, response);
        } else if (info1.rtnype.equals("ACTION")) {
            try {
                dealAction(request, response, info1);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (InstantiationException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IllegalAccessException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (NoSuchMethodException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IllegalArgumentException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (InvocationTargetException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        } else if (info1.rtnype.equals("SUNOUTDOWN")) {
            String lng = request.getParameter("jd");
            String lat = request.getParameter("wd");
            String str1 = SunRiseSet.getSunrise(new BigDecimal(lng), new BigDecimal(lat), new Date());
            String str2 = SunRiseSet.getSunset(new BigDecimal(lng), new BigDecimal(lat), new Date());
            
            Map<String, List> list3 = new HashMap<String, List>();
            Map map = new HashMap();
            map.put("rc", str1);
            map.put("rl", str2);
            List li2 = new ArrayList();
            li2.add(map);
            list3.put("cl", li2);
            String jsonstr = JSONObject.fromObject(list3).toString();
            response.setContentType("text/json; charset=UTF-8");
            response.getOutputStream().write(jsonstr.getBytes("UTF-8"));

            //xxxxxxxxxx
        } else if (info1.rtnype.equals("DOWNLOAD")) {
            dealDownLoad(request, response, info1);
        } else if (info1.rtnype.equals("EMAIL")) {
            Map map = dealMail(request, response, info1);
            setJsonMap(map, request, response);
        } else if (info1.rtnype.equals("UPLOAD")) {
            try {
                String jsonstr = null;
                List bbb = dealAttach(request, response, info1);
                jsonstr = JSONArray.fromObject(bbb).toString();
                System.out.println("jsonstr");
                response.setContentType("text/json; charset=UTF-8");
                response.getOutputStream().write(jsonstr.getBytes("UTF-8"));
                
            } catch (FileUploadException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        } else if (info1.rtnype.equals("TREE")) {
            try {
                List<TreeInfo> treeInfos1 = dealTree(request, response, info1);
                setJsonList(treeInfos1, request, response);
            } catch (SQLException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else if (info1.rtnype.equals("RELOAD")) {
            try {
                XmlApplicationContext cgx = new XmlApplicationContext("");
                cgx.emptydata();
                cgx.InitAll(request.getServletContext());
            } catch (Exception ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else if (info1.rtnype.equals("JSON")) {
            Map<String, List> list3 = dealJson(request, response, info1);
            
            String jsonstr = null;
            if ((info1.var != null) && (!info1.var.equals("") && list3.containsKey(info1.var))) {
                if (info1.var.equals("bootstrap")) {
                    List aa = list3.get(info1.var);
                    Map docType = new HashMap();
                    
                    List listpage = new ArrayList();
                    String limit = request.getParameter("limit");
                    String skip = request.getParameter("skip");
                    String type = request.getParameter("page");
                    if (type != null && type.equals("ALL")) {
                        docType.put("total", aa.size());
                        docType.put("rows", aa);
                        
                    } else {
                        int ilimit = 0;
                        int iskip = 0;
                        if (limit != null && !limit.equals("")) {
                            if (skip != null && !skip.equals("")) {
                                ilimit = Integer.parseInt(limit);
                                iskip = Integer.parseInt(skip);
                            }
                        }
                        
                        int subend = iskip + ilimit;
                        if (subend > aa.size()) {
                            subend = aa.size();
                        }
                        listpage = aa.subList(iskip, subend);
                        docType.put("total", aa.size());
                        docType.put("rows", listpage);
                        
                    }
                    jsonstr = JSONObject.fromObject(docType).toString();
                    
                } else if (info1.var.equals("bootstrap1")) {
                    List aa = list3.get(info1.var);
                    Map docType = new HashMap();
                    
                    List listpage = new ArrayList();
                    List listret = new ArrayList();
                     List listret1 = new ArrayList();
                    String limit = request.getParameter("limit");
                    String skip = request.getParameter("skip");
                    String type = request.getParameter("page");
                    if (type != null && type.equals("ALL")) {
                        docType.put("total", aa.size());
                        docType.put("rows", aa);
                        
                    } else {
                        int ilimit = 0;
                        int iskip = 0;
                        if (limit != null && !limit.equals("")) {
                            if (skip != null && !skip.equals("")) {
                                ilimit = Integer.parseInt(limit);
                                iskip = Integer.parseInt(skip);
                            }
                        }
                          
                        int subend = iskip + ilimit;
                        if (subend > aa.size()) {
                            subend = aa.size();
                        }
                       listpage = aa.subList(iskip/96, subend);   
                       iskip=iskip/96;
                       listret1 = dealReport(listpage, listret, iskip, subend);
                       int total=listret1.size();
                        if (listret1.size()>=96) {
                            
                             listret = listret1.subList(0, ilimit);
                        }
//                        if (subend*96>=listret1.size()) {
//                            subend=listret1.size();
//                        }
               
                       
                        
                        

//                        for (int i = 0; i < listpage.size(); i++) {
//                            HashMap<String, String> hm1 = (HashMap<String, String>) listpage.get(i);
//                            String dayalise = hm1.get("dayalis");
//                            String day = hm1.get("day");
//                            String voltage = hm1.get("voltage"); //电压
//                            String electric = hm1.get("electric");//电流
//                            String power = hm1.get("power");//电能量
//                            String activepower = hm1.get("activepower"); //有功功率
//                            String powerfactor = hm1.get("powerfactor"); //功率因数
//                            System.out.println("dayalise:" + dayalise);
//
//                            JSONObject v = null;
//                            JSONObject e = null;
//                            JSONObject p = null;
//                            JSONObject a = null;
//                            JSONObject pf = null;
//                            if (voltage != null) {
//                                v = JSONObject.fromObject(voltage.toString());  //电压
//                            }
//
//                            if (electric != null) {
//                                e = JSONObject.fromObject(electric.toString());  //电流
//                            }
//
//                            if (power != null) {
//                                p = JSONObject.fromObject(power.toString());  //功率因数
//                            }
//
//                            if (activepower != null) {
//                                a = JSONObject.fromObject(activepower.toString()); //有功功率 
//                            }
//
//                            if (powerfactor != null) {
//                                pf = JSONObject.fromObject(powerfactor.toString());
//                            }
//
//                            int time1 = 0;
//
//                            int len1 = 0;
//                            int len2 = 0;
//                            int len3 = 0;
//                            int len4 = 0;
//                            if (v != null) {
//                                len1 = v.getInt("len");
//                            }
//
//                            if (e != null) {
//                                len1 = v.getInt("len");
//                            }
//                            if (p != null) {
//                                len1 = v.getInt("len");
//                            }
//                            if (a != null) {
//                                len1 = v.getInt("len");
//                            }
//
//                            if (len1 == 96 || len2 == 96 || len3 == 96 || len4 == 96) {
//                                String APFstr = "";
//                                String BPFstr = "";
//                                String CPFstr = "";
//                                String DPFstr = "";
//                                if (pf != null) {
//                                    APFstr = pf.getString("A");
//                                    BPFstr = pf.getString("B");
//                                    CPFstr = pf.getString("C");
//                                    DPFstr = pf.getString("D");
//                                }
//
//                                String AVstr = "";
//                                String BVstr = "";
//                                String CVstr = "";
//                                if (v != null) {
//                                    AVstr = v.getString("A");
//                                    BVstr = v.getString("B");
//                                    CVstr = v.getString("C");
//                                }
//
//                                String AEstr = "";
//                                String BEstr = "";
//                                String CEstr = "";
//                                if (e != null) {
//                                    AEstr = e.getString("A");
//                                    BEstr = e.getString("B");
//                                    CEstr = e.getString("C");
//                                }
//
//                                String AAstr = "";
//                                String BAstr = "";
//                                String CAstr = "";
//                                if (a != null) {
//                                    AAstr = a.getString("A");
//                                    BAstr = a.getString("B");
//                                    CAstr = a.getString("C");
//                                }
//
//                                String APstr = "";
//                                if (p != null) {
//                                    APstr = p.getString("A");
//                                }
//
////                                String APstr = p.getString("A");
//                                String[] PAstrArr = APstr.split("\\|");
//
//                                String[] AVstrArr = AVstr.split("\\|");
//                                String[] BVstrArr = BVstr.split("\\|");
//                                String[] CVstrArr = CVstr.split("\\|");
//
//                                String[] AEstrArr = AEstr.split("\\|");
//                                String[] BEstrArr = BEstr.split("\\|");
//                                String[] CEstrArr = CEstr.split("\\|");
//
//                                String[] AAstrArr = AAstr.split("\\|");
//                                String[] BAstrArr = BAstr.split("\\|");
//                                String[] CAstrArr = CAstr.split("\\|");
//
//                                String[] APFstrArr = APFstr.split("\\|");
//                                String[] BPFstrArr = BPFstr.split("\\|");
//                                String[] CPFstrArr = CPFstr.split("\\|");
//                                String[] DPFstrArr = DPFstr.split("\\|");
//
//                                for (int j = 0; j < len1; j++) {
//                                    Map map33 = new HashMap();
//                                    int f = time1 % 60;
//                                    int s = time1 / 60;
//                                    String a3 = "0";
//                                    String t1 = "";
//                                    String t2 = "";
//
//                                    if (f < 10) {
//                                        t1 = a3 + String.valueOf(f);
//                                    } else {
//                                        t1 = String.valueOf(f);
//                                    }
//                                    if (s < 10) {
//                                        t2 = a3 + String.valueOf(s);
//                                    } else {
//                                        t2 = String.valueOf(s);
//                                    }
//
//                                    String time2 = t2 + ":" + t1;
//                                    map33.put("time", time2);
//                                    if (AVstrArr.length > 1) {
//                                        map33.put("VAField", AVstrArr[j]);
//                                        map33.put("VBField", BVstrArr[j]);
//                                        map33.put("VCField", CVstrArr[j]);
//                                    }
//
//                                    if (AEstrArr.length > 1) {
//                                        map33.put("EAField", AEstrArr[j]);
//                                        map33.put("EBField", BEstrArr[j]);
//                                        map33.put("ECField", CEstrArr[j]);
//                                    }
//
//                                    if (AAstrArr.length > 1) {
//                                        map33.put("ACTIVEAField", AAstrArr[j]);
//                                        map33.put("ACTIVEBField", BAstrArr[j]);
//                                        map33.put("ACTIVECField", CAstrArr[j]);
//                                    }
//
//                                    if (APFstrArr.length > 1) {
//                                        map33.put("FACTORAField", APFstrArr[j]);
//                                        map33.put("FACTORBField", BPFstrArr[j]);
//                                        map33.put("FACTORCField", CPFstrArr[j]);
//                                        map33.put("FACTORDField", DPFstrArr[j]);
//                                    }
//                                    if (PAstrArr.length > 1) {
//                                        map33.put("power", PAstrArr[j]);
//                                    }
//
//                                    map33.put("day", day);
//                                    map33.put("dayalise", dayalise);
//                                    listret.add(map33);
//                                    time1 += 15;
//                                }
//
//                            }
//                        }
                        docType.put("total",total);
                        docType.put("rows", listret);
                        System.out.println("l:" + listret.size());
                    }
                    jsonstr = JSONObject.fromObject(docType).toString();
                    
                } else if (info1.var.equals("list")) {
                    List aa = list3.get(info1.var);
                    jsonstr = JSONArray.fromObject(aa).toString();
                    
                } else {
                    List aa = list3.get(info1.var);
                    jsonstr = JSONObject.fromObject(list3).toString();
                    
                }
            } else {
                try {
                    jsonstr = JSONObject.fromObject(list3).toString();
                } catch (JSONException ex) {
                    Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, jsonstr);
            response.setContentType("text/json; charset=UTF-8");
            response.getOutputStream().write(jsonstr.getBytes("UTF-8"));
        }
    }

    /*
    *  处理运行报表
     */
    public List dealReport(List listpage, List retlist, int iminit, int isuspend) {
        List listret = new ArrayList();
        for (int i = 0; i < listpage.size(); i++) {
            HashMap<String, String> hm1 = (HashMap<String, String>) listpage.get(i);
            String dayalise = hm1.get("dayalis");
            String day = hm1.get("day");
            String voltage = hm1.get("voltage"); //电压
            String electric = hm1.get("electric");//电流
            String power = hm1.get("power");//电能量
            String activepower = hm1.get("activepower"); //有功功率
            String powerfactor = hm1.get("powerfactor"); //功率因数
            System.out.println("dayalise:" + dayalise);
            
            JSONObject v = JSONObject.fromObject(voltage.toString());  //电压
            JSONObject e = JSONObject.fromObject(electric.toString()); //电流
            JSONObject p = JSONObject.fromObject(power.toString());   //电能量
            JSONObject a = JSONObject.fromObject(activepower.toString());  //有功功率
            JSONObject pf = JSONObject.fromObject(powerfactor.toString()); //功率因数
            int time1 = 0;
            int vlen = v.getInt("len");
            int Elen = e.getInt("len");
            int Plen = p.getInt("len");
            int Alen = a.getInt("len");
            int PFlen = pf.getInt("len");

//            JSONObject v = null;
//            JSONObject e = null;
//            JSONObject p = null;
//            JSONObject a = null;
//            JSONObject pf = null;
//            if (voltage != null) {
//                v = JSONObject.fromObject(voltage.toString());  //电压
//            }
//
//            if (electric != null) {
//                e = JSONObject.fromObject(electric.toString());  //电流
//            }
//
//            if (power != null) {
//                p = JSONObject.fromObject(power.toString());  //功率因数
//            }
//
//            if (activepower != null) {
//                a = JSONObject.fromObject(activepower.toString()); //有功功率 
//            }
//
//            if (powerfactor != null) {
//                pf = JSONObject.fromObject(powerfactor.toString());
//            }
//            int time1 = 0;
//            int len1 = 0;
//            int len2 = 0;
//            int len3 = 0;
//            int len4 = 0;
//            if (v != null) {
//                len1 = v.getInt("len");
//            }
//            if (e != null) {
//                len1 = v.getInt("len");
//            }
//            if (p != null) {
//                len1 = v.getInt("len");
//            }
//            if (a != null) {
//                len1 = v.getInt("len");
//            }
            if (vlen == 96 || Elen == 96 || Plen == 96 || Alen == 96 || PFlen == 96) {
                String[] AVstrArr = vlen == 96 ? v.getString("A").split("\\|") : new String[1];
                String[] BVstrArr = vlen == 96 ? v.getString("B").split("\\|") : new String[1];
                String[] CVstrArr = vlen == 96 ? v.getString("C").split("\\|") : new String[1];
                
                String[] AEstrArr = Elen == 96 ? e.getString("A").split("\\|") : new String[1];
                String[] BEstrArr = Elen == 96 ? e.getString("B").split("\\|") : new String[1];
                String[] CEstrArr = Elen == 96 ? e.getString("C").split("\\|") : new String[1];
                
                String[] AAstrArr = Alen == 96 ? a.getString("A").split("\\|") : new String[1];
                String[] ABstrArr = Alen == 96 ? a.getString("B").split("\\|") : new String[1];
                String[] ACstrArr = Alen == 96 ? a.getString("C").split("\\|") : new String[1];
                
                String[] APFstrArr = PFlen == 96 ? pf.getString("A").split("\\|") : new String[1];
                String[] BPFstrArr = PFlen == 96 ? pf.getString("B").split("\\|") : new String[1];
                String[] CPFstrArr = PFlen == 96 ? pf.getString("C").split("\\|") : new String[1];
                String[] DPFstrArr = PFlen == 96 ? pf.getString("D").split("\\|") : new String[1];
                
                String[] PstrArr = Plen == 96 ? p.getString("A").split("\\|") : new String[1];
                
                for (int j = 0; j < 96; j++) {
                     Map map33 = new HashMap();
                    int f = time1 % 60;
                    int s = time1 / 60;
                    String a3 = "0";
                    String t1 = "";
                    String t2 = "";

                    if (f < 10) {
                        t1 = a3 + String.valueOf(f);
                    } else {
                        t1 = String.valueOf(f);
                    }
                    if (s < 10) {
                        t2 = a3 + String.valueOf(s);
                    } else {
                        t2 = String.valueOf(s);
                    }

                    String time2 = t2 + ":" + t1;
                    map33.put("time", time2);
                    if (vlen>j) {
                        map33.put("VAField", AVstrArr[j]);
                        map33.put("VBField", BVstrArr[j]);
                        map33.put("VCField", CVstrArr[j]);
                    }

                    if (Elen>j) {
                        map33.put("EAField", AEstrArr[j]);
                        map33.put("EBField", BEstrArr[j]);
                        map33.put("ECField", CEstrArr[j]);
                    }

                    if (Alen > j) {
                        map33.put("ACTIVEAField", AAstrArr[j]);
                        map33.put("ACTIVEBField", ABstrArr[j]);
                        map33.put("ACTIVECField", ACstrArr[j]);
                    }

                    if (PFlen > j) {
                        map33.put("FACTORAField", APFstrArr[j]);
                        map33.put("FACTORBField", BPFstrArr[j]);
                        map33.put("FACTORCField", CPFstrArr[j]);
                        map33.put("FACTORDField", DPFstrArr[j]);
                    }
                    if (Plen>j) {
                          map33.put("power", PstrArr[j]);
                    }
  

                    map33.put("day", day);
                    map33.put("dayalise", dayalise);
                    listret.add(map33);
                    time1 += 15;                  
                }
                
            }
           
            
        }
        return listret;
    }
        /*
     * 返回页面
         */
    public String dealpage(HttpServletRequest request, HttpServletResponse response, Info info1) throws ServletException, IOException {
        List li = info1.sqlLis;
        for (int i = 0; i < li.size(); i++) {
            XsqlInfo aa = (XsqlInfo) li.get(i);
            try {
                if (aa.type.equals("SQL")) {
                    String aaString = "开始执行查询:[" + aa.sql + "]";
                    Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, aaString);
                    List lib = DbConn.query(aa.sql);
                    System.out.print(lib);
                    if (aa.var != null || !aa.var.equals("")) {
                        request.setAttribute(aa.var, lib);
                    }
                }
                if (aa.type.equals("DDL")) {
                    String aaString = "开始执行更新:[" + aa.sql + "]";
                    Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, aaString);
                    if (aa.var != null || !aa.var.equals("")) {
                        int lib = DbConn.exceptQuery(aa.sql);
                        request.setAttribute(aa.var, lib);
                    }
                }
                if (aa.type.equals("PROC")) {
                    String aaString = "开始存储过程:[" + aa.sql + "]";
                    Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, aaString);
                    List list1 = DbConn.execProcedure(aa.sql, aa.outpara);
                    Map<String, String> map1 = (Map<String, String>) list1.get(i);
                    for (Map.Entry<String, String> entry : map1.entrySet()) {
                        request.setAttribute(entry.getKey(), entry.getValue());
                    }
                    
                }
            } catch (SQLException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return info1.url;
    }

    /*
     * 返回树形json数据
     */
    public List<TreeInfo> dealTree(HttpServletRequest request, HttpServletResponse response, Info info1) throws SQLException, Exception {
        //menuid
        List li = info1.sqlLis;
        Map<String, List> mapbig = new HashMap<String, List>();
        List<TreeInfo> listTreeInfos = null;
        for (int i = 0; i < li.size(); i++) {
            XsqlInfo aa = (XsqlInfo) li.get(i);
            if (aa.type.equals("SQL")) {
                String aaString = "开始执行树查询:[" + aa.sql + "]";
                Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, aaString);
                List lib = DbConn.query(aa.sql);  //一级菜单
                listTreeInfos = TreeInfo.formatTree(lib);
            }
        }
        return listTreeInfos;
    }

    /*
     * 返回JSON数据
     */
    public Map<String, List> dealJson(HttpServletRequest request, HttpServletResponse response, Info info1) {
        List li = info1.sqlLis;
        Map<String, List> mapbig = new HashMap<String, List>();
        for (int i = 0; i < li.size(); i++) {
            XsqlInfo aa = (XsqlInfo) li.get(i);
            try {
                if (aa.type.equals("SQL")) {
                    String aaString = "开始执行查询:[" + aa.sql + "]";
                    Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, aaString);
                    List lib = DbConn.query(aa.sql);
                    if (aa.var == null) {
                        continue;
                    }
                    mapbig.put(aa.var, lib);
                }
                if (aa.type.equals("DDL")) {
                    String aaString = "开始执行更新:[" + aa.sql + "]";
                    Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, aaString);
                    int lib = DbConn.exceptQuery(aa.sql);
                    if (aa.var == null) {
                        continue;
                    }
                    Map map = new HashMap();
                    map.put("count", lib);
                    List li2 = new ArrayList();
                    li2.add(map);
                    mapbig.put(aa.var, li2);
                }
                if (aa.type.equals("PROC")) {
                    String aaString = "开始存储过程:[" + aa.sql + "]";
                    Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, aaString);
                    List list1 = DbConn.execProcedure(aa.sql, aa.outpara);
                    mapbig.put(aa.var, list1);
                }
                
            } catch (SQLException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return mapbig;
    }
    
    public void dealAction(HttpServletRequest request, HttpServletResponse response, Info info1) throws ClassNotFoundException, InstantiationException, IllegalAccessException, NoSuchMethodException, IllegalArgumentException, InvocationTargetException {
        List li = info1.sqlLis;
        Map<String, List> mapbig = new HashMap<String, List>();
        for (int i = 0; i < li.size(); i++) {
            XsqlInfo aa = (XsqlInfo) li.get(i);
            String strClassString = aa.sql.trim();
            if (Class.forName(strClassString) == null) {
                continue;
            }
            Object dddObject = Class.forName(strClassString).newInstance();
//            Class[] cls = {HttpServletRequest.class, HttpServletRequest.class};
            Class[] cls = {javax.servlet.http.HttpServletRequest.class, javax.servlet.http.HttpServletResponse.class, com.mylib.Info.class};
            String methodString = request.getParameter(aa.id);
            if (methodString != null) {
                Method aaMethod = dddObject.getClass().getMethod(methodString.trim(), cls);
                aaMethod.invoke(dddObject, request, response, info1);
            }
            String aaString = "调用" + dddObject.getClass() + "的" + methodString + "方法";
            Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, aaString);
            
        }
    }

    /*
     * 处理上传
     */
    public List dealAttach(HttpServletRequest request, HttpServletResponse response, Info info1) throws IOException, FileUploadException, Exception {
        List li = info1.sqlLis;
        ServletContext context = getServletContext();
        String webPath = context.getRealPath("");
        List retList = new ArrayList();
        for (int i = 0; i < li.size(); i++) {
            XsqlInfo aa = (XsqlInfo) li.get(i);
            String path = aa.sql;
            
            String filePath = "";
            String temPath = "temp";
            temPath = webPath + "//" + temPath;
            System.out.println("文件存放目录、临时文件目录准备完毕 ...");
            //PrintWriter pw = response.getWriter();
            DiskFileItemFactory diskFactory = new DiskFileItemFactory();
            // threshold 极限、临界值，即硬盘缓存 1G 
            //diskFactory.setSizeThreshold(1000 * 1024 * 1024);
            // repository 贮藏室，即临时文件目录  
            //diskFactory.setRepository(new File(temPath));
            ServletFileUpload upload = new ServletFileUpload(diskFactory);
            upload.setHeaderEncoding("UTF-8");
            // 设置允许上传的最大文件大小 1G 
            upload.setSizeMax(1000 * 1024 * 1024);
            // 解析HTTP请求消息头  
            List<FileItem> fileItems = upload.parseRequest(new ServletRequestContext(request));
            Iterator<FileItem> iter = fileItems.iterator();
            
            while (iter.hasNext()) {
                FileItem item = (FileItem) iter.next();
                if (item.isFormField()) {
                    System.out.println("处理表单内容 ...");
                    String tagName = item.getFieldName();
                    String fcontent = item.getString("utf-8");
                    if (tagName.equals("fpath") == true) {
                        filePath = webPath + "\\" + fcontent;
                        
                    }
                    System.out.println(filePath);
                }
            }
            
            iter = fileItems.iterator();
            while (iter.hasNext()) {
                FileItem item = (FileItem) iter.next();
                if (item.isFormField()) {
//                    System.out.println("处理表单内容 ...");
//                    String tagName = item.getFieldName();
//                    String fcontent = item.getString("utf-8");
//                    if (tagName == "fpath") {
//                        filePath = fcontent;
//                    }
//                    System.out.println(fcontent);
                } else {
                    Map<String, String> mapbig = new HashMap<String, String>();
                    Logger.getLogger(InitServlet.class.getName()).log(Level.WARNING, "处理上传的文件 ...");
                    String filename = item.getName();
                    String aaString = "完整的文件名：" + filename;
                    Logger.getLogger(InitServlet.class.getName()).log(Level.WARNING, aaString);
                    int index = filename.lastIndexOf("\\");
                    filename = filename.substring(index + 1, filename.length());
                    String strfileguid = java.util.UUID.randomUUID().toString();
                    mapbig.put("guid", strfileguid);
                    mapbig.put("attach", filename);
                    mapbig.put("path", filePath);
                    retList.add(mapbig);
                    long fileSize = item.getSize();
                    if ("".equals(filename) && fileSize == 0) {
                        Logger.getLogger(InitServlet.class.getName()).log(Level.WARNING, "文件名为空....");
                    }
                    File uploadFile = new File(filePath + "/" + filename);
                    if (!uploadFile.exists()) {
                        uploadFile.createNewFile();
                    }
                    item.write(uploadFile);
                }
            }
            
        }
        return retList;
        //如果路径不存在，则创建路径

    }

    /*
     * 发送邮件
     */
    public Map<String, String> dealMail(HttpServletRequest request, HttpServletResponse response, Info info1) throws UnsupportedEncodingException {
        List li = info1.sqlLis;
        Map<String, String> mapbig = new HashMap<String, String>();
        MailUtils sendmail = new MailUtils();
        
        for (int i = 0; i < li.size(); i++) {
            XsqlInfo aa = (XsqlInfo) li.get(i);
            String strTemp = aa.var;
            String MialHostString = "smtp.126.com";
            String MialUserString = null;
            String MialPassString = null;
            String MialFromString = null;
            String MialSubjectString;
            String MialContentString;
            String MialToString;
            String MailAttachString;
            Pattern pattern = Pattern.compile("\\*__\\*");
            String MailInfo[] = pattern.split(strTemp);
            
            if (MailInfo.length >= 4) {
                MialHostString = MailInfo[0];
                MialUserString = MailInfo[1];
                MialPassString = MailInfo[2];
                MialFromString = MailInfo[3];
            }
            MialSubjectString = aa.fpara.get("subject_").toString();
            MialContentString = aa.fpara.get("content_").toString();
            MialToString = aa.fpara.get("to_").toString();
            MailAttachString = aa.fpara.get("attach_").toString();
            sendmail.setHost(MialHostString);
            sendmail.setUserName(MialUserString);
            sendmail.setPassWord(MialPassString);
            
            sendmail.setFrom(MialFromString);
            sendmail.setSubject(MialSubjectString);
            sendmail.setContent(MialContentString);
            Pattern patternAttach = Pattern.compile("\\*__\\*");
            String MailMutiAttach[] = patternAttach.split(MailAttachString);
            String MailMutiTo[] = patternAttach.split(MialToString);
            for (int j = 0; j < MailMutiAttach.length; j++) {
                
                if (MailMutiAttach[j].indexOf("\\") == -1) {
                    continue;
                }
                sendmail.attachfile(MailMutiAttach[j]);
            }
            for (int z = 0; z < MailMutiTo.length; z++) {
                sendmail.setTo(MailMutiTo[z]);
                boolean ret1 = sendmail.sendMail();
                if (ret1) {
                    mapbig.put(MialToString, "success!.....");
                } else {
                    mapbig.put(MialToString, "fail!.....");
                }
                
            }
            
        }
        
        return mapbig;
    }

    /*
     * 下载附件
     */
    public void dealDownLoad(HttpServletRequest request, HttpServletResponse response, Info info1) throws IOException {
        List li = info1.sqlLis;
        Map<String, String> mapbig = new HashMap<String, String>();
        ServletContext context = getServletContext();
        String webPath = context.getRealPath("");
        for (int i = 0; i < li.size(); i++) {
            String filePath = "upload";
            String filehName;
            XsqlInfo aa = (XsqlInfo) li.get(i);
            if (aa.fpara.get("filepath_") != null) {
                filePath = aa.fpara.get("filepath_").toString();
            }
            if (aa.fpara.get("filename_") == null) {
                System.out.println("下载的文件名为空");
                mapbig.put("rs", "error");
            }
            filehName = aa.fpara.get("filename_").toString();
            String path1 = webPath + "\\" + filePath + "\\" + filehName;
            File serverFile = new File(path1);
            
            String fileNameString = null;
            try {
                fileNameString = java.net.URLEncoder.encode(filehName, "utf-8");
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(ControlServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            response.setHeader("Content-disposition", "attachment;filename=" + fileNameString);
            response.setContentType("text/html");
            long filelenL = serverFile.length();
            String lenString = String.valueOf(filelenL);
            response.setHeader("content_Length", lenString);
            OutputStream serverOutputStream = response.getOutputStream();
            FileInputStream fileInputStream = new FileInputStream(serverFile);
            byte bytes[] = new byte[1024];
            int len;
            while ((len = fileInputStream.read(bytes)) != -1) {
                serverOutputStream.write(bytes, 0, len);
            }
            mapbig.put("filename", filehName);
            serverOutputStream.close();
            fileInputStream.close();
        }
    }
    
    public Map<String, String> dealSession(HttpServletRequest request, HttpServletResponse response, Info info1) throws IOException {
        List li = info1.sqlLis;
        Map<String, String> mapbig = new HashMap<String, String>();
        for (int i = 0; i < li.size(); i++) {
            XsqlInfo aa = (XsqlInfo) li.get(i);
            if (aa.id.equals("get")) {
                String string1[] = aa.sql.split(":");
                for (int j = 0; j < string1.length; j++) {
                    String aaString = string1[j].trim();
                    String str1 = (String) request.getSession().getAttribute(aaString);
                    mapbig.put(string1[j], str1);
                }
            }
        }
        return mapbig;
        
    }
    
    public void setJsonMap(Map m, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String jsonstr;
        jsonstr = JSONArray.fromObject(m).toString();
        Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, jsonstr);
        response.getOutputStream().write(jsonstr.getBytes("UTF-8"));
        response.setContentType("text/json; charset=UTF-8");
    }
    
    public void setJsonList(List li, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String jsonstr;
        jsonstr = JSONArray.fromObject(li).toString();
        Logger.getLogger(ControlServlet.class.getName()).log(Level.INFO, jsonstr);
        response.getOutputStream().write(jsonstr.getBytes("UTF-8"));
        response.setContentType("text/json; charset=UTF-8");
    }

    /**
     * 处理表单内容
     *
     * @param item
     * @param pw
     * @throws Exception
     */
    public void processFormField(FileItem item, PrintWriter pw)
            throws Exception {
        String tagName = item.getFieldName();
        String fileName = item.getString("utf-8");
        // pw.println(tagName + " : " + fileName + "\r\n");
    }
    
}
