package com.javafast.modules.gen.entity;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.javafast.common.persistence.DataEntity;
import com.javafast.common.utils.StringUtils;

/**
 * 业务表Entity
 */
public class GenTable extends DataEntity<GenTable> {
	
	private static final long serialVersionUID = 1L;
	private String name; 	// 表名称
	private String comments;		// 表描述
	private String className;		// 实体类名称
	private String parentTable;		// 关联父表
	private String parentTableFk;		// 关联父表外键
	private List<GenTableColumn> columnList = Lists.newArrayList();	// 表列
	private String nameLike; 	// 按名称模糊查询
	private List<String> pkList; // 当前表主键列表
	private GenTable parent;	// 父表对象
	private List<GenTable> childList = Lists.newArrayList();	// 子表列表
	
	private String category;		// 生成模板分类
	private String packageName;		// 生成包路径
	private String moduleName;		// 生成模块名
	private String subModuleName;		// 生成子模块名
	private String functionName;		// 生成功能名
	private String functionNameSimple;		// 生成功能名（简写）
	private String functionAuthor;		// 生成功能作者
	private String pageModel;    //页面模型，0： 默认弹窗； 1：跳转新页面
	private String flag; 	// 0：保存； 1：保存并生成代码	
	private Boolean replaceFile = false;	// 是否替换现有文件    0：不替换；1：替换文件	
	private String treeData;  //左树右表的情况下，树形列表对象

	
	public GenTable() {
		super();
	}

	public GenTable(String id){
		super(id);
	}

	@Length(min=1, max=200)
	public String getName() {
		return StringUtils.lowerCase(name);
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	public String getParentTable() {
		return StringUtils.lowerCase(parentTable);
	}

	public void setParentTable(String parentTable) {
		this.parentTable = parentTable;
	}

	public String getParentTableFk() {
		return StringUtils.lowerCase(parentTableFk);
	}

	public void setParentTableFk(String parentTableFk) {
		this.parentTableFk = parentTableFk;
	}

	public List<String> getPkList() {
		return pkList;
	}

	public void setPkList(List<String> pkList) {
		this.pkList = pkList;
	}

	public String getNameLike() {
		return nameLike;
	}

	public void setNameLike(String nameLike) {
		this.nameLike = nameLike;
	}

	public GenTable getParent() {
		return parent;
	}

	public void setParent(GenTable parent) {
		this.parent = parent;
	}

	public List<GenTableColumn> getColumnList() {
		return columnList;
	}

	public void setColumnList(List<GenTableColumn> columnList) {
		this.columnList = columnList;
	}

	public List<GenTable> getChildList() {
		return childList;
	}

	public void setChildList(List<GenTable> childList) {
		this.childList = childList;
	}
	
	/**
	 * 获取列名和说明
	 * @return
	 */
	public String getNameAndComments() {
		return getName() + (comments == null ? "" : "  :  " + comments);
	}

	/**
	 * 获取导入依赖包字符串
	 * @return
	 */
	public List<String> getImportList(){
		List<String> importList = Lists.newArrayList(); // 引用列表
		for (GenTableColumn column : getColumnList()){
			if (column.getIsNotBaseField() || ("1".equals(column.getIsQuery()) && "between".equals(column.getQueryType())
							&& ("createDate".equals(column.getSimpleJavaField()) || "updateDate".equals(column.getSimpleJavaField())))){
				// 导入类型依赖包， 如果类型中包含“.”，则需要导入引用。
				if (StringUtils.indexOf(column.getJavaType(), ".") != -1 && !importList.contains(column.getJavaType())){
					importList.add(column.getJavaType());
				}
			}
			if (column.getIsNotBaseField()){
				// 导入JSR303、Json等依赖包
				for (String ann : column.getAnnotationList()){
					if (!importList.contains(StringUtils.substringBeforeLast(ann, "("))){
						importList.add(StringUtils.substringBeforeLast(ann, "("));
					}
				}
			}
		}
		// 如果有子表，则需要导入List相关引用
		if (getChildList() != null && getChildList().size() > 0){
			if (!importList.contains("java.util.List")){
				importList.add("java.util.List");
			}
			if (!importList.contains("com.google.common.collect.Lists")){
				importList.add("com.google.common.collect.Lists");
			}
		}
		return importList;
	}
	
	/**
	 * 是否存在父类
	 * @return
	 */
	public Boolean getParentExists(){
		return parent != null && StringUtils.isNotBlank(parentTable) && StringUtils.isNotBlank(parentTableFk);
	}

	/**
	 * 是否存在create_date列
	 * @return
	 */
	public Boolean getCreateDateExists(){
		for (GenTableColumn c : columnList){
			if ("create_date".equals(c.getName())){
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 是否存在update_date列
	 * @return
	 */
	public Boolean getUpdateDateExists(){
		for (GenTableColumn c : columnList){
			if ("update_date".equals(c.getName())){
				return true;
			}
		}
		return false;
	}

	/**
	 * 是否存在del_flag列
	 * @return
	 */
	public Boolean getDelFlagExists(){
		for (GenTableColumn c : columnList){
			if ("del_flag".equals(c.getName())){
				return true;
			}
		}
		return false;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getPackageName() {
		return packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}

	public String getModuleName() {
		return moduleName;
	}

	public void setModuleName(String moduleName) {
		this.moduleName = moduleName;
	}

	public String getSubModuleName() {
		return subModuleName;
	}

	public void setSubModuleName(String subModuleName) {
		this.subModuleName = subModuleName;
	}

	public String getFunctionName() {
		return functionName;
	}

	public void setFunctionName(String functionName) {
		this.functionName = functionName;
	}

	public String getFunctionNameSimple() {
		return functionNameSimple;
	}

	public void setFunctionNameSimple(String functionNameSimple) {
		this.functionNameSimple = functionNameSimple;
	}

	public String getFunctionAuthor() {
		return functionAuthor;
	}

	public void setFunctionAuthor(String functionAuthor) {
		this.functionAuthor = functionAuthor;
	}

	public String getPageModel() {
		return pageModel;
	}

	public void setPageModel(String pageModel) {
		this.pageModel = pageModel;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public Boolean getReplaceFile() {
		return replaceFile;
	}

	public void setReplaceFile(Boolean replaceFile) {
		this.replaceFile = replaceFile;
	}

	public String getTreeData() {
		return treeData;
	}

	public void setTreeData(String treeData) {
		this.treeData = treeData;
	}
	
	
}


