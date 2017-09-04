package com.ocj.oms.mobile.bean.items;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * Created by liu on 2017/6/12.
 */

public class ColorsSizeBean implements Serializable{
    ArrayList<SpecItemBean> sizes;
    ArrayList<SpecItemBean> colorsizes;
    ArrayList<SpecItemBean> colors;

    public ArrayList<SpecItemBean> getSizes() {
        return sizes;
    }

    public void setSizes(ArrayList<SpecItemBean> sizes) {
        this.sizes = sizes;
    }

    public ArrayList<SpecItemBean> getColorsizes() {
        return colorsizes;
    }

    public void setColorsizes(ArrayList<SpecItemBean> colorsizes) {
        this.colorsizes = colorsizes;
    }

    public ArrayList<SpecItemBean> getColors() {
        return colors;
    }

    public void setColors(ArrayList<SpecItemBean> colors) {
        this.colors = colors;
    }
}
