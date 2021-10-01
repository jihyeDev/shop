package vo;

public class Category {
	private String categoryName;
	private String categoryState;
	private String updateDate;
	private String createDate;
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getCategoryState() {
		return categoryState;
	}
	public void setCategoryState(String categoryState) {
		this.categoryState = categoryState;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
	@Override
	public String toString() {
		return "Category [categoryName=" + categoryName + ", categoryState=" + categoryState + ", updateDate="
				+ updateDate + ", createDate=" + createDate + "]";
	}
}
