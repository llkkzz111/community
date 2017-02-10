package com.choudao.equity.selector;

import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;

import com.choudao.equity.R;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.selector.model.PhotoModel;
import com.choudao.equity.view.TopView;

import java.util.List;

/**
 * @author Aizaz AZ
 */
public class BasePhotoPreviewActivity extends BaseActivity implements OnPageChangeListener, OnClickListener {

    protected List<PhotoModel> photos;
    protected int current;
    protected boolean isUp;
    private ViewPager mViewPager;
    private TopView topView;
    /**
     * 图片点击事件回调
     */
    private OnClickListener photoItemClickListener = new OnClickListener() {
        @Override
        public void onClick(View v) {
            if (!isUp) {
                isUp = true;
            } else {
                isUp = false;
            }
        }
    };
    private PagerAdapter mPagerAdapter = new PagerAdapter() {

        @Override
        public int getCount() {
            if (photos == null) {
                return 0;
            } else {
                return photos.size();
            }
        }

        @Override
        public View instantiateItem(final ViewGroup container, final int position) {
            PhotoPreview photoPreview = new PhotoPreview(getApplicationContext());
            ((ViewPager) container).addView(photoPreview);
            photoPreview.loadImage(photos.get(position));
            photoPreview.setOnClickListener(photoItemClickListener);
            return photoPreview;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view == object;
        }

    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_photopreview);
        mViewPager = (ViewPager) findViewById(R.id.vp_base_app);
        mViewPager.setOnPageChangeListener(this);
        topView = (TopView) findViewById(R.id.topview);
        topView.setTitle("图片预览");
        topView.getLeftView().setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    /**
     * 绑定数据，更新界面
     */
    protected void bindData() {
        mViewPager.setAdapter(mPagerAdapter);
        mViewPager.setCurrentItem(current);
    }

    @Override
    public void onClick(View v) {
//        if (v.getId() == R.id.btn_send) {
//            setResult(RESULT_OK);
//            finish();
//    }

    }

    @Override
    public void onPageScrollStateChanged(int arg0) {

    }

    @Override
    public void onPageScrolled(int arg0, float arg1, int arg2) {

    }

    @Override
    public void onPageSelected(int arg0) {
        current = arg0;
        updatePercent();
    }

    protected void updatePercent() {
        //tvPercent.setText((current + 1) + "/" + photos.size());
    }
}
