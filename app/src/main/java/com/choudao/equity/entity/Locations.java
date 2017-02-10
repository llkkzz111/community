package com.choudao.equity.entity;

import java.util.List;

/**
 * Created by liuzhao on 16/11/8.
 */

public class Locations {

    private List<Location1> locations;
    private String  hex;

    public String getHex() {
        return hex;
    }

    public void setHex(String hex) {
        this.hex = hex;
    }

    public List<Location1> getLocations() {
        return locations;
    }

    public void setLocations(List<Location1> locations) {
        this.locations = locations;
    }


    class Location1 {
        String id;
        String name;
        List<Location> locations;

        public List<Location> getLocations() {
            return locations;
        }

        public void setLocations(List<Location> locations) {
            this.locations = locations;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }
    }

    class Location {
        String name;
        String id;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }
    }
}
