package com.choudao.equity.view.bottomsheet;

import android.annotation.SuppressLint;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Build;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.FrameLayout;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.choudao.equity.R;

import java.util.ArrayList;
import java.util.List;

@SuppressLint("ViewConstructor")
public class IntentPickerSheetView extends FrameLayout {
    protected GridView appGrid;
    protected TextView titleView;
    protected List<ActivityInfo> mixins = new ArrayList<>();
    protected Adapter adapter;
    private int columnWidthDp = 100;
    public IntentPickerSheetView(Context context, String title, OnIntentPickedListener listener, List<ActivityInfo> activityInfoList) {
        this(context, title, listener);
        this.mixins = activityInfoList;
    }
    public IntentPickerSheetView(Context context, String title, final OnIntentPickedListener listener) {
        super(context);
        inflate(context, R.layout.grid_sheet_view, this);
        appGrid = (GridView) findViewById(R.id.grid);
        titleView = (TextView) findViewById(R.id.title);
        titleView.setText(title);
        appGrid.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                listener.onIntentPicked(adapter.getItem(position));
            }
        });
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        for (ActivityInfo activityInfo : mixins) {
            if (activityInfo.iconLoadTask != null) {
                activityInfo.iconLoadTask.cancel(true);
                activityInfo.iconLoadTask = null;
            }
        }
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        this.adapter = new Adapter(getContext(), mixins);
        appGrid.setAdapter(this.adapter);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int width = MeasureSpec.getSize(widthMeasureSpec);
        final float density = getResources().getDisplayMetrics().density;
        getResources().getDimensionPixelSize(R.dimen.bottomsheet_default_sheet_width);
        appGrid.setNumColumns((int) (width / (columnWidthDp * density)));
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        // Necessary for showing elevation on 5.0+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            setOutlineProvider(new Util.ShadowOutline(w, h));
        }
    }

    public interface OnIntentPickedListener {
        void onIntentPicked(ActivityInfo activityInfo);
    }

    /**
     * Represents an item in the picker grid
     */
    public static class ActivityInfo {
        public final String label;
        public Drawable icon;
        public ComponentName componentName;
        public ResolveInfo resolveInfo;
        public Object tag;
        private AsyncTask<Void, Void, Drawable> iconLoadTask;

        public ActivityInfo(Drawable icon, String label, Context context, Class<?> clazz) {
            this.icon = icon;
            resolveInfo = null;
            this.label = label;
            this.componentName = new ComponentName(context, clazz.getName());
        }

        public ActivityInfo(ResolveInfo resolveInfo, CharSequence label, ComponentName componentName) {
            this.resolveInfo = resolveInfo;
            this.label = label.toString();
            this.componentName = componentName;

        }

        public ActivityInfo(Drawable drawable, CharSequence label, String tag, ComponentName componentName) {
            this.label = label.toString();
            this.icon = drawable;
            this.tag = tag;
            this.componentName = componentName;
        }

        public Intent getConcreteIntent(Intent intent) {
            Intent concreteIntent = new Intent(intent);
            concreteIntent.setComponent(componentName);
            return concreteIntent;
        }
    }

    private class Adapter extends BaseAdapter {

        final LayoutInflater inflater;
        private PackageManager packageManager;

        public Adapter(Context context, List<ActivityInfo> mixins) {
            inflater = LayoutInflater.from(context);
            packageManager = context.getPackageManager();
        }

        @Override
        public int getCount() {
            return mixins.size();
        }

        @Override
        public ActivityInfo getItem(int position) {
            return mixins.get(position);
        }

        @Override
        public long getItemId(int position) {
            return mixins.get(position).componentName.hashCode();
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            final ViewHolder holder;

            if (convertView == null) {
                convertView = inflater.inflate(R.layout.sheet_grid_item, parent, false);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }

            final ActivityInfo info = mixins.get(position);
            if (info.iconLoadTask != null) {
                info.iconLoadTask.cancel(true);
                info.iconLoadTask = null;
            }
            if (info.icon != null) {
                holder.icon.setImageDrawable(info.icon);
            } else {
                holder.icon.setImageDrawable(getResources().getDrawable(R.color.divider_gray));
                info.iconLoadTask = new AsyncTask<Void, Void, Drawable>() {
                    @Override
                    protected Drawable doInBackground(@NonNull Void... params) {
                        return info.resolveInfo.loadIcon(packageManager);
                    }

                    @Override
                    protected void onPostExecute(@NonNull Drawable drawable) {
                        info.icon = drawable;
                        info.iconLoadTask = null;
                        holder.icon.setImageDrawable(drawable);
                    }
                };
                info.iconLoadTask.execute();
            }
            holder.label.setText(info.label);

            return convertView;
        }

        class ViewHolder {
            final ImageView icon;
            final TextView label;

            ViewHolder(View root) {
                icon = (ImageView) root.findViewById(R.id.icon);
                label = (TextView) root.findViewById(R.id.label);
            }
        }

    }

}
