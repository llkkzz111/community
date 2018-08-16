package com.community.equity.selector;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.CompoundButton;
import android.widget.GridView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.community.equity.R;
import com.community.equity.base.BaseActivity;
import com.community.equity.selector.adapter.AlbumAdapter;
import com.community.equity.selector.adapter.PhotoSelectorAdapter;
import com.community.equity.selector.model.AlbumModel;
import com.community.equity.selector.model.PhotoModel;
import com.community.equity.selector.utils.AnimationUtil;
import com.community.equity.selector.utils.PhotoSelectorDomain;
import com.community.equity.selector.utils.Util;
import com.community.equity.utils.FileUtils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class PhotoSelectorActivity extends BaseActivity implements
        PhotoItem.onItemClickListener, PhotoItem.onPhotoItemCheckedListener, OnClickListener, AdapterView.OnItemClickListener {

    private static final int REQUEST_CAMERA = 1;
    private static final int REQUEST_CODE_CAPTURE_CAMEIA = 8;//从相机获取图片
    public static String RECCENT_PHOTO;
    public ArrayList<PhotoModel> selected;
    String cameraPath = null;
    private int MAX_IMAGE = 9;
    private GridView gvPhotos;
    private TextView tvSend;
    private TextView tvAlbum;
    private PhotoSelectorDomain photoSelectorDomain;
    private PhotoSelectorAdapter photoAdapter;
    private String albumName;
    private TopView topView;
    private ListView lvAblum;
    private AlbumAdapter albumAdapter;
    private RelativeLayout layoutAlbum;
    private OnLocalAlbumListener albumListener = new OnLocalAlbumListener() {
        @Override
        public void onAlbumLoaded(List<AlbumModel> albums) {
            albumAdapter.update(albums);
        }
    };
    private OnLocalReccentListener reccentListener = new OnLocalReccentListener() {

        @Override
        public void onPhotoLoaded(List<PhotoModel> photos) {
            for (PhotoModel model : photos) {
                if (selected.contains(model)) {
                    model.setChecked(true);
                }
            }
            PhotoModel cameraFirst = new PhotoModel();
            cameraFirst.setOriginalPath("default");
            photos.add(0, cameraFirst);
            photoAdapter.update(photos);
            gvPhotos.smoothScrollToPosition(0); // 滚动到顶端
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        RECCENT_PHOTO = getResources().getString(R.string.recent_photos);
        MAX_IMAGE = getIntent().getIntExtra(IntentKeys.KEY_MAX, -1);
        albumName = RECCENT_PHOTO;
        setContentView(R.layout.activity_photoselector);
        layoutAlbum = (RelativeLayout) findViewById(R.id.layout_album_ar);
        gvPhotos = (GridView) findViewById(R.id.gv_photos_ar);
        tvSend = (TextView) findViewById(R.id.tv_send);
        tvAlbum = (TextView) findViewById(R.id.tv_album_ar);
        lvAblum = (ListView) findViewById(R.id.lv_ablum_ar);
        topView = (TopView) findViewById(R.id.topview);
        topView.setTitle(RECCENT_PHOTO);
        topView.getLeftView().setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        if (MAX_IMAGE == 1) {
            tvSend.setVisibility(View.GONE);
        }
        selected = new ArrayList<>();
        albumAdapter = new AlbumAdapter(getApplicationContext(),
                new ArrayList<AlbumModel>());
        lvAblum.setAdapter(albumAdapter);
        photoSelectorDomain = new PhotoSelectorDomain(getApplicationContext());

        tvSend.setOnClickListener(this);
        tvAlbum.setOnClickListener(this);
        lvAblum.setOnItemClickListener(this);

        photoAdapter = new PhotoSelectorAdapter(this, new ArrayList<PhotoModel>(), this, this);
        photoAdapter.setMaxImage(MAX_IMAGE);
        gvPhotos.setAdapter(photoAdapter);
        getData();
    }

    private void getData() {
        if (null != albumName) {
            if (albumName.equals(RECCENT_PHOTO)) {
                photoSelectorDomain.getReccent(reccentListener); // 更新最近照片
            } else {
                gvPhotos.setScrollY(0);
                photoSelectorDomain.getAlbum(albumName, reccentListener);
            }
            photoSelectorDomain.updateAlbum(albumListener);

        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_send:
                ok();
                break;
            case R.id.tv_album_ar:
                album();
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_CAPTURE_CAMEIA && resultCode == RESULT_OK) {
            PhotoModel cameiaPhoto = new PhotoModel();
            cameiaPhoto.setOriginalPath(cameraPath);
            sendSinglePhoto(cameiaPhoto);
        }
        if (requestCode == 2 && resultCode == RESULT_OK) {
            ok();
        }
        if (requestCode == Util.CAMERA_PHOTO && resultCode == RESULT_OK) {

            if (Util.cameraFile != null && Util.cameraFile.exists()) {
                String str_choosed_img = Util.cameraFile.getAbsolutePath();
                PhotoModel cameraPhotoModel = new PhotoModel();
                cameraPhotoModel.setChecked(true);
                cameraPhotoModel.setOriginalPath(str_choosed_img);
                selected.add(cameraPhotoModel);

                MediaScannerConnection.scanFile(PhotoSelectorActivity.this,
                        new String[]{str_choosed_img}, null, null);

                if (photoAdapter.getCount() == 0) {
                    PhotoModel cameraFirst = new PhotoModel();
                    cameraFirst.setOriginalPath("default");
                    photoAdapter.add(0, cameraFirst);
                }
                if (selected.size() > 0) {
                    tvSend.setText("发送(" + selected.size() + "/9)");
                    photoAdapter.add(1, cameraPhotoModel);
                } else {
                    tvSend.setText(R.string.text_send);
                    photoAdapter.add(cameraPhotoModel);
                }
            }
        }

        if (requestCode == REQUEST_CAMERA && resultCode == RESULT_OK) {
            PhotoModel photoModel = new PhotoModel(Util.query(
                    getApplicationContext(), data.getData()));
            if (selected.size() >= MAX_IMAGE) {
                Toast.makeText(
                        this,
                        String.format(
                                getString(R.string.max_img_limit_reached),
                                MAX_IMAGE), Toast.LENGTH_SHORT).show();
                photoModel.setChecked(false);
                photoAdapter.notifyDataSetChanged();
            } else {
                if (!selected.contains(photoModel)) {
                    selected.add(photoModel);
                }
            }
            ok();
        }
    }

    private void sendSinglePhoto(PhotoModel cameiaPhoto) {
        selected.add(cameiaPhoto);
        Intent intent = new Intent();
        intent.putExtra(IntentKeys.KEY_PHOTO_LIST, selected);
        setResult(Activity.RESULT_OK, intent);
        finish();
    }

    /**
     * 完成
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    private void ok() {
        if (selected.size() > MAX_IMAGE) {
            Toast.makeText(
                    this,
                    String.format(getString(R.string.max_img_limit_reached),
                            MAX_IMAGE), Toast.LENGTH_SHORT).show();
            return;
        } else if (selected.size() == 0) {
            Toast.makeText(this, "请选择图片", Toast.LENGTH_SHORT).show();
        } else {
            Intent intent = new Intent();
            intent.putExtra(IntentKeys.KEY_PHOTO_LIST, selected);
            setResult(Activity.RESULT_OK, intent);
            finish();
        }
    }

    /**
     * 清空选中的图片
     */
    private void reset() {
        selected.clear();
        tvSend.setText(R.string.text_send);
        finish();
    }

    /**
     * 点击查看照片
     */
    @Override
    public void onItemClick(int position) {
        if (position == 0) {
            getImageFromCamera();
            return;
        }
        if (MAX_IMAGE == 1) {
            sendSinglePhoto((PhotoModel) photoAdapter.getItem(position));
        } else {
            Bundle bundle = new Bundle();
            bundle.putInt("position", position);
            bundle.putString("album", albumName);
            Util.launchActivity(this, PhotoPreviewActivity.class, bundle);
        }
    }

    /**
     * 跳转系统拍照界面,并
     */
    protected void getImageFromCamera() {
        String state = Environment.getExternalStorageState();
        if (state.equals(Environment.MEDIA_MOUNTED)) {
            Intent getImageByCamera = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
            cameraPath = FileUtils.CAMERA_CACHE_PATH + System.currentTimeMillis() + ".jpg";
            File tempFile = new File(cameraPath);
            if (tempFile.exists()) tempFile.delete();
            tempFile.getParentFile().mkdirs();
            getImageByCamera.putExtra(
                    MediaStore.EXTRA_OUTPUT, Uri.fromFile(tempFile));
            startActivityForResult(getImageByCamera, REQUEST_CODE_CAPTURE_CAMEIA);
        } else {
            Toast.makeText(mContext, "请确认已经插入SD卡", Toast.LENGTH_SHORT).show();
        }
    }

    /**
     * 显示隐藏选择图片文件夹列表
     */
    private void album() {
        if (layoutAlbum.getVisibility() == View.GONE) {
            popAlbum();
        } else {
            hideAlbum();
        }
    }

    /**
     * 显示
     */
    private void popAlbum() {
        layoutAlbum.setVisibility(View.VISIBLE);
        new AnimationUtil(getApplicationContext(), R.anim.translate_up_current)
                .setLinearInterpolator().startAnimation(layoutAlbum);
    }

    /**
     * 隐藏
     */
    private void hideAlbum() {
        new AnimationUtil(getApplicationContext(), R.anim.translate_down)
                .setLinearInterpolator().startAnimation(layoutAlbum);
        layoutAlbum.setVisibility(View.GONE);
    }

    @Override
    /** 照片选中状态改变之后 */
    public void onCheckedChanged(PhotoModel photoModel, CompoundButton buttonView, boolean isChecked) {
        if (isChecked) {
            if (!selected.contains(photoModel))
                selected.add(photoModel);
        } else {
            selected.remove(photoModel);
        }

        if (selected.size() > MAX_IMAGE) {
            Toast.makeText(
                    this,
                    String.format(getString(R.string.max_img_limit_reached),
                            MAX_IMAGE), Toast.LENGTH_SHORT).show();
            return;
        } else if (selected.size() > 0) {
            tvSend.setText("发送(" + selected.size() + "/9)");
        } else {
            tvSend.setText(R.string.text_send);
        }
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        AlbumModel current = (AlbumModel) parent.getItemAtPosition(position);
        for (int i = 0; i < parent.getCount(); i++) {
            AlbumModel album = (AlbumModel) parent.getItemAtPosition(i);
            if (i == position)
                album.setCheck(true);
            else
                album.setCheck(false);
        }
        albumAdapter.notifyDataSetChanged();
        hideAlbum();
        tvAlbum.setText(current.getName());
        topView.setTitle(current.getName());

        if (current.getName().equals(RECCENT_PHOTO))
            photoSelectorDomain.getReccent(reccentListener);
        else
            photoSelectorDomain.getAlbum(current.getName(), reccentListener); //
    }

    @Override
    public void onBackPressed() {
        if (layoutAlbum.getVisibility() == View.VISIBLE) {
            hideAlbum();
        } else
            super.onBackPressed();
    }


    /**
     * 获取本地图库照片回调
     */
    public interface OnLocalReccentListener {
        void onPhotoLoaded(List<PhotoModel> photos);
    }

    /**
     * 获取本地相册信息回调
     */
    public interface OnLocalAlbumListener {
        void onAlbumLoaded(List<AlbumModel> albums);
    }
}
