package com.ocj.oms.mobile.ui.personal.order.dialog;

import android.app.DialogFragment;
import android.os.Bundle;
import android.os.Parcelable;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.Display;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.Window;
import android.view.WindowManager;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.EventResultsItem;
import com.ocj.oms.mobile.ui.adapter.CutEventAdapter;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * Created by xiao on 2017/8/17.
 */

public class CutEventDialogFragment extends DialogFragment {


    @BindView(R.id.rv) RecyclerView rv;
    private CutEventAdapter mAdapter;
    private List<EventResultsItem> list;
    private OnEventClickListener listener;
    View view;


    public static CutEventDialogFragment newInstance(List<EventResultsItem> list) {
        CutEventDialogFragment fragment = new CutEventDialogFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelableArrayList("list", (ArrayList<? extends Parcelable>) list);
        fragment.setArguments(bundle);
        return fragment;
    }

    public CutEventDialogFragment() {

    }

    public void setListener(OnEventClickListener listener) {
        this.listener = listener;
    }


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(DialogFragment.STYLE_NORMAL,R.style.MyDialog);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
        view = LayoutInflater.from(getActivity()).inflate(R.layout.dialog_cut_event_layout, null, false);
        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        list = getArguments().getParcelableArrayList("list");
        mAdapter = new CutEventAdapter(getActivity(), list);
        mAdapter.setListener(new CutEventAdapter.OnItemClickListener() {
            @Override
            public void click(int position, String url) {
                listener.itemClick(position, url);
            }
        });
        rv = (RecyclerView) getView().findViewById(R.id.rv);
        rv.setLayoutManager(new LinearLayoutManager(getActivity()));
        rv.setAdapter(mAdapter);

        Window dialogWindow = getDialog().getWindow();
        WindowManager m = getActivity().getWindowManager();
        Display d = m.getDefaultDisplay(); // 获取屏幕宽、高用
        WindowManager.LayoutParams p = dialogWindow.getAttributes(); // 获取对话框当前的参数值
        if (list.size() > 1) {
            p.height = (int) (d.getHeight() * 0.6); // 高度设置为屏幕的0.6
        }else{
            p.height = WindowManager.LayoutParams.WRAP_CONTENT; // 高度设置为屏幕的0.6
        }
        dialogWindow.setGravity(Gravity.CENTER);
        getDialog().setCancelable(true);
        getDialog().setCanceledOnTouchOutside(true);
    }

    @Override
    public void onStart() {
        super.onStart();
        forceWrapContent(view);
        Window dialogWindow = getDialog().getWindow();
        WindowManager m = getActivity().getWindowManager();
        Display d = m.getDefaultDisplay(); // 获取屏幕宽、高用
        WindowManager.LayoutParams p = dialogWindow.getAttributes(); // 获取对话框当前的参数值
        p.height = WindowManager.LayoutParams.WRAP_CONTENT; // 高度设置为屏幕的0.6
    }

    protected void forceWrapContent(View v) {
        // Start with the provided view
        View current = v;

        // Travel up the tree until fail, modifying the LayoutParams
        do {
            // Get the parent
            ViewParent parent = current.getParent();

            // Check if the parent exists
            if (parent != null) {
                // Get the view
                try {
                    current = (View) parent;
                } catch (ClassCastException e) {
                    // This will happen when at the top view, it cannot be cast to a View
                    break;
                }

                // Modify the layout
                current.getLayoutParams().height = ViewGroup.LayoutParams.WRAP_CONTENT;
            }
        } while (current.getParent() != null);

        // Request a layout to be re-done
        current.requestLayout();
    }

    public interface OnEventClickListener {
        void itemClick(int position, String url);
    }

}
