package com.ocj.oms.mobile.ui.selecter;

import android.graphics.Bitmap;
import android.widget.CheckBox;

import java.io.Serializable;

/**
 * @author Aizaz
 */


public class PhotoModel implements Serializable {

    private static final long serialVersionUID = 1L;

    private String originalPath;
    private boolean isChecked;

    private CheckBox checkBox;
    private Bitmap mBitmap;


    public PhotoModel(String originalPath, boolean isChecked) {
        super();
        this.originalPath = originalPath;
        this.isChecked = isChecked;
    }

    public PhotoModel(String originalPath) {
        this.originalPath = originalPath;
    }

    public PhotoModel() {
    }

    public Bitmap getmBitmap() {
        return mBitmap;
    }

    public void setmBitmap(Bitmap mBitmap) {
        this.mBitmap = mBitmap;
    }

    public String getOriginalPath() {
        return originalPath;
    }

    public void setOriginalPath(String originalPath) {
        this.originalPath = originalPath;
    }

    public boolean isChecked() {
        return isChecked;
    }

//	@Override
//	public boolean equals(Object o) {
//		if (o.getClass() == getClass()) {
//			PhotoModel model = (PhotoModel) o;
//			if (this.getOriginalPath().equals(model.getOriginalPath())) {
//				return true;
//			}
//		}
//		return false;
//	}

    public void setChecked(boolean isChecked) {
        System.out.println("checked " + isChecked + " for " + originalPath);
        this.isChecked = isChecked;
    }

    public CheckBox getCheckBox() {
        return checkBox;
    }

    public void setCheckBox(CheckBox checkBox) {
        this.checkBox = checkBox;
    }

    /* (non-Javadoc)
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((originalPath == null) ? 0 : originalPath.hashCode());
        return result;
    }

    /* (non-Javadoc)
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (!(obj instanceof PhotoModel)) {
            return false;
        }
        PhotoModel other = (PhotoModel) obj;
        if (originalPath == null) {
            if (other.originalPath != null) {
                return false;
            }
        } else if (!originalPath.equals(other.originalPath)) {
            return false;
        }
        return true;
    }

}
