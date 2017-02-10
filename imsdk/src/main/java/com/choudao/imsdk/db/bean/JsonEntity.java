package com.choudao.imsdk.db.bean;

// THIS CODE IS GENERATED BY greenDAO, EDIT ONLY INSIDE THE "KEEP"-SECTIONS

// KEEP INCLUDES - put your custom includes here
// KEEP INCLUDES END
/**
 * Entity mapped to table "json_table".
 */
public class JsonEntity implements java.io.Serializable {

    private Long id;
    private String json_type;
    private String json_info;

    // KEEP FIELDS - put your custom fields here
    // KEEP FIELDS END

    public JsonEntity() {
    }

    public JsonEntity(Long id) {
        this.id = id;
    }

    public JsonEntity(Long id, String json_type, String json_info) {
        this.id = id;
        this.json_type = json_type;
        this.json_info = json_info;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getJson_type() {
        return json_type;
    }

    public void setJson_type(String json_type) {
        this.json_type = json_type;
    }

    public String getJson_info() {
        return json_info;
    }

    public void setJson_info(String json_info) {
        this.json_info = json_info;
    }

    // KEEP METHODS - put your custom methods here
    // KEEP METHODS END

}
