package com.ocj.oms.mobile.ui.global;

import android.content.Intent;
import android.support.v4.widget.DrawerLayout;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.AppCompatButton;
import android.support.v7.widget.AppCompatImageButton;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.PinyinUtils;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.DistrictBrandBean;
import com.ocj.oms.mobile.bean.RelationBean;
import com.ocj.oms.mobile.bean.items.CmsContentBean;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.global.widget.GlobalCategeryLayout;
import com.ocj.oms.mobile.ui.global.widget.GlobalTabCatLayout;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.view.GlobalFilterLayout;
import com.ocj.oms.mobile.view.GlobalFilterLayout2;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;
import com.oushangfeng.pinnedsectionitemdecoration.PinnedHeaderItemDecoration;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;

import static com.ocj.oms.mobile.IntentKeys.GLOBAL_CONTENT_TYPE;
import static com.ocj.oms.mobile.IntentKeys.GLOBAL_LG_ROUP;
import static com.ocj.oms.mobile.IntentKeys.GLOBAL_SEARCH_ITEM;
import static com.ocj.oms.mobile.ui.global.widget.GlobalTabCatLayout.SHOW_TYPE_AREA;
import static com.ocj.oms.mobile.ui.global.widget.GlobalTabCatLayout.SHOW_TYPE_BRAND;
import com.ocj.oms.mobile.R;


/**
 * 全球购内容界面
 * Created by shizhang.cai on 2017/6/7.
 */
@Route(path = RouterModule.AROUTER_PATH_GLOBAL_LIST)
public class GlobalListActivity extends BaseActivity implements BaseQuickAdapter.RequestLoadMoreListener, SwipeRefreshLayout.OnRefreshListener {

    private String TAG = GlobalListActivity.class.getSimpleName();

    @BindView(R.id.drawerLayout) DrawerLayout drawerLayout;
    @BindView(R.id.recyclerview) RecyclerView recyclerview;
    @BindView(R.id.filterLayout) GlobalFilterLayout filterLayout;
    @BindView(R.id.filterLayout2) GlobalFilterLayout2 filterLayout2;
    @BindView(R.id.screenbackBtn) AppCompatImageButton screenbackBtn;
    @BindView(R.id.categeryLayout) GlobalCategeryLayout categeryLayout;

    @BindView(R.id.areaCatLayout) GlobalTabCatLayout areaBrandCatLayout;


    @BindView(R.id.headLayout) RelativeLayout headLayout;    //头部布局

    @BindView(R.id.iv_back) ImageView ivBack;

    @BindView(R.id.iv_sort) ImageView ivSort;

    @BindView(R.id.swipeRefresh) SwipeRefreshLayout swipeRefresh;

    @BindView(R.id.tv_title) TextView mTvTitle;

    String[] indexStr = {"A", "B", "C", "D", "E", "F", "G", "H", "I",
            "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "W", "X",
            "Y", "Z"};

    private List<CmsItemsBean> gridList = new ArrayList<>();
    //热门地区
    private static final int AREATYPE = 1;
    //品牌
    private static final int BRANDTYPE = 2;
    //过滤
    private static final int FILTERTYPE = 3;

    /**
     * grid布局
     */
    private GlobalGridAdapter gridAdapter;

    private boolean isLinear = false;

    public List<Contact> brandList = new ArrayList<>();
    public List<Contact> brandSelectList = new ArrayList<>();

    public List<Contact> areaList = new ArrayList<>();
    public List<Contact> areaSelectList = new ArrayList<>();


    public List<Contact> typeList = new ArrayList<>();
    public List<Contact> typeSelectList = new ArrayList<>();


    String id = "";//6278280185984843776,用于获取分页数据

    String salesSort = "";
    String priceSort = "";
    String singleProduct = "0";//超值单品

    /**
     * 线性布局
     */
    private GlobalLinearAdapter linearAdapter;


    private String brandCondition = "";
    private String areaCondition = "";
    private String cateCondition = "";

    private String searchItem = "";//用于获取筛选项数据
    private String lgroup = "";

    private int current_page = 1;
    private static final int PAGE_SIZE = 20;

    private View notDataView;
    private View errorView;

    private String contentType = "";

    private String defBrandCondition = "";
    private String defAreaCondition = "";
    private String defCateCondition = "";

    public static final String TWO_YUAN_KEY = "200add";


    private CmsContentBean mBean;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_global_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706A007);

        Intent intent = getIntent();
        if (intent.getStringExtra(GLOBAL_SEARCH_ITEM) != null) {
            searchItem = intent.getStringExtra(GLOBAL_SEARCH_ITEM);
        }
        if (!TextUtils.isEmpty(intent.getStringExtra(GLOBAL_LG_ROUP))) {
            lgroup = intent.getStringExtra(GLOBAL_LG_ROUP);
            if (lgroup.equals(TWO_YUAN_KEY)) {
                singleProduct = "1";
                filterLayout2.setSingle(true);
            }
        }

        if (!TextUtils.isEmpty(intent.getStringExtra("title"))) {
            mTvTitle.setText(intent.getStringExtra("title"));
        }

        //contentType 1分类 3品牌 4国家
        if (!TextUtils.isEmpty(intent.getStringExtra(GLOBAL_CONTENT_TYPE))) {
            contentType = intent.getStringExtra(GLOBAL_CONTENT_TYPE);
            if (contentType.equals("1")) {
                defCateCondition = lgroup;
            } else if (contentType.equals("3")) {
                defBrandCondition = lgroup;
                setBrandOption(lgroup, searchItem);
            } else if (contentType.equals("4")) {
                defAreaCondition = lgroup;
                setAreaOption(lgroup, searchItem);
            }
        }
        initView();
        filterLayout.setFilterLayoutClick(new GlobalFilterLayout.FilterLayoutClick() {
            @Override
            public void onTabAllClick() {
                //点击全部
                clearOption();
                getSearchData();
            }

            @Override
            public void onSaleClick(String type) {
                salesSort = type;
                getSearchData();
            }

            @Override
            public void onPriceSortClick(String type) {
                //点击价格，自动将销量置0
                priceSort = type;
                salesSort = "";
                getSearchData();
            }

            @Override
            public void onOptionClick() {
                showDrawLayout(3);
            }
        });
        filterLayout2.setFilterLayoutClick(new GlobalFilterLayout2.FilterLayoutClick() {

            @Override
            public void onTabClick(int position, AppCompatButton button) {
                if (position == 0) {
                    //超值单选
                    boolean flag = (boolean) button.getTag();
                    if (flag) {
                        singleProduct = "1";
                        clearAreaOption();
                        clearBrandOption();
                    } else {
                        singleProduct = "0";
                    }
                    filterLayout.setAllStatus(false);
                    getSearchData();
                } else if (position == 1) {
                    //热门地区
                    showDrawLayout(1);
                } else if (position == 2) {
                    //品牌
                    showDrawLayout(2);
                }
            }
        });
        drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
        swipeRefresh.setOnRefreshListener(this);
        initRecyclerView();

        //获取筛选项数据
        getOptionData();

        //获取首屏数据
        getFirstPageData();

    }

    /**
     * 清除地区选择
     */
    private void clearAreaOption() {
        areaCondition = "";
        areaSelectList.clear();
        filterLayout2.setAreBtnText(null);
    }

    /**
     * 清除品牌选择
     */
    private void clearBrandOption() {
        brandCondition = "";
        brandSelectList.clear();
        filterLayout2.setBrandBtnText(null);
    }

    /**
     * 清除单选
     */
    private void clearSingle() {
        singleProduct = "0";
        filterLayout2.setSingle(false);
    }

    private void clearOption() {
        clearSingle();
        clearAreaOption();
        clearBrandOption();
    }


    private void setAreaOption(String lggroup, String content) {
        filterLayout2.setAreBtnText(content);
        Contact area = new Contact();
        area.setCode(lggroup);
        area.setName(content);
        area.setIndex(PinyinUtils.getPinyinFirstLetter(content).toUpperCase());
        areaSelectList.add(area);
    }

    private void setBrandOption(String lggroup, String content) {
        filterLayout2.setBrandBtnText(content);
        Contact brand = new Contact();
        brand.setCode(lggroup);
        brand.setName(content);
        brand.setIndex(PinyinUtils.getPinyinFirstLetter(content).toUpperCase());
        brandSelectList.add(brand);
    }

    /**
     * 获取列表数据
     */
    private void getSearchData() {
        current_page = 1;
        getSearchData(id, "1", "20", brandCondition, areaCondition, cateCondition, singleProduct, salesSort, priceSort);
    }

    /**
     * 获取第一屏数据
     */
    private void getFirstPageData() {
        showLoading();
        Map<String, Object> params = new HashMap<>();
        params.put("id", "AP1706A007");
        params.put("lgroup", lgroup);
        params.put("contentType", contentType);
        new ItemsMode(mContext).getRelation(params, new ApiResultObserver<CmsContentBean>(mContext) {
            @Override
            public void onSuccess(CmsContentBean apiResult) {
                hideLoading();
                mBean = apiResult;
                Log.i(TAG, apiResult.getCodeValue());
                List<PackageListBean> listBean2 = apiResult.getPackageList();
                if (null != listBean2 && listBean2.size() > 0) {
                    //提取id，用于获取分页数据
                    current_page = 2;
                    List<CmsItemsBean> list = listBean2.get(0).getComponentList();
                    if (list != null && list.size() > 0) {
                        id = list.get(0).getId();
                    }
                    List<CmsItemsBean> omponentList = null;
                    if (list != null) {
                        omponentList = list.get(0).getComponentList();
                    }
                    if (omponentList != null) {
                        gridList.clear();
                        gridList.addAll(omponentList);
                        if (isLinear) {
                            linearAdapter.notifyDataSetChanged();
                            linearAdapter.loadMoreComplete();
                        } else {
                            gridAdapter.notifyDataSetChanged();
                            gridAdapter.loadMoreComplete();
                        }
                    }
                    swipeRefresh.setRefreshing(false);
                    linearAdapter.setEnableLoadMore(true);
                    gridAdapter.setEnableLoadMore(true);
                }

            }

            @Override
            public void onError(ApiException e) {
                Log.i(TAG, e.getMessage());
                hideLoading();
                swipeRefresh.setRefreshing(false);
                linearAdapter.setEnableLoadMore(true);
                gridAdapter.setEnableLoadMore(true);
            }
        });
    }

    /**
     * 初始化布局
     */
    private void initView() {

        notDataView = getLayoutInflater().inflate(R.layout.global_list_empty_view, (ViewGroup) recyclerview.getParent(), false);
        notDataView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                onRefresh();
            }
        });
        errorView = getLayoutInflater().inflate(R.layout.global_list_error_view, (ViewGroup) recyclerview.getParent(), false);
        errorView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onRefresh();
            }
        });

        initListener();
        initScreen1();
        initScreen2();
    }

    /**
     * 初始化点击事件
     */
    private void initListener() {
        ivBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                RouterModule.onRouteBack();
                finish();
            }
        });
        screenbackBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawer(Gravity.RIGHT);
            }
        });
        ivSort.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (getAdapter().getData() == null || getAdapter().getData().size() == 0) {
                    return;
                }
                if (isLinear) {
                    ivSort.setImageResource(R.drawable.icon_listcolumn);
                    isLinear = false;
                    initGrid();
                } else {
                    ivSort.setImageResource(R.drawable.icon_listrow);
                    isLinear = true;
                    initLinear();
                }
            }
        });
    }

    /**
     * 初始化列表
     */
    private void initRecyclerView() {

        linearAdapter = new GlobalLinearAdapter(this, R.layout.item_global_linear_layout, gridList);
        linearAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter baseQuickAdapter, View view, int i) {
                Map<String, Object> params1 = getParams();
                OcjStoreDataAnalytics.trackEvent(mContext, gridList.get(i).getCodeValue(), gridList.get(i).getTitle(), params1);
                RouterModule.cacheRouteActivity(RouterModule.jsonObject.toString());
                RouterModule.globalListToDetail(gridList.get(i).getContentCode(), searchItem, contentType, lgroup);
            }
        });
        gridAdapter = new GlobalGridAdapter(this, R.layout.item_global_grid, gridList);
        gridAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(BaseQuickAdapter baseQuickAdapter, View view, int i) {
                Map<String, Object> params1 = getParams();
                OcjStoreDataAnalytics.trackEvent(mContext, gridList.get(i).getCodeValue(), gridList.get(i).getTitle(), params1);
                RouterModule.cacheRouteActivity(RouterModule.jsonObject.toString());
                RouterModule.globalListToDetail(gridList.get(i).getContentCode(), searchItem, contentType, lgroup);
            }
        });
        recyclerview.addItemDecoration(// 设置粘性标签对应的类型
                new PinnedHeaderItemDecoration.Builder(2)
                        .setDividerId(R.drawable.global_divider)
                        .enableDivider(true)
                        .disableHeaderClick(false)
                        .create());
        linearAdapter.setOnLoadMoreListener(this, recyclerview);
        gridAdapter.setOnLoadMoreListener(this, recyclerview);
        initGrid();

    }

    /**
     * 初始化线性布局
     */
    private void initLinear() {
        recyclerview.setLayoutManager(new GridLayoutManager(this, 1));
        recyclerview.setAdapter(linearAdapter);
    }

    /**
     * 初始化grid布局
     */
    private void initGrid() {
        recyclerview.setLayoutManager(new GridLayoutManager(this, 2));
        recyclerview.setAdapter(gridAdapter);
    }

    public Map<String, Object> getParams() {
        Map<String, Object> params = new HashMap<>();
        params.put("pID", mBean.getCodeValue());
        params.put("vID", mBean.getPageVersionName());
        return params;
    }


    /**
     * 显示drawlayout界面
     *
     * @param type type = 0 热门地区
     *             type = 1 品牌
     *             type = 3 筛选
     */
    private void showDrawLayout(int type) {
        if (type == AREATYPE) {
            if (areaList.size() == 0) {
                return;
            }
            areaBrandCatLayout.setShow_type(SHOW_TYPE_AREA);
            areaBrandCatLayout.setShow_type(SHOW_TYPE_AREA);
            areaBrandCatLayout.setSlideTitle("地区");
            areaBrandCatLayout.setTabs("热门地区", "字母排序");
            areaBrandCatLayout.setVisibility(View.VISIBLE);
            areaBrandCatLayout.setTagButton(filterLayout2.areaBtn);
            categeryLayout.setVisibility(View.GONE);
            areaBrandCatLayout.setData(areaList, areaSelectList);
            drawerLayout.openDrawer(Gravity.RIGHT);
        } else if (type == BRANDTYPE) {
            if (brandList.size() == 0) {
                return;
            }
            areaBrandCatLayout.setShow_type(SHOW_TYPE_BRAND);
            areaBrandCatLayout.setSlideTitle("品牌");
            areaBrandCatLayout.setTabs("推荐品牌", "字母排序");
            areaBrandCatLayout.setVisibility(View.VISIBLE);
            areaBrandCatLayout.setTagButton(filterLayout2.brandBtn);
            categeryLayout.setVisibility(View.GONE);

            areaBrandCatLayout.setData(brandList, brandSelectList);
            drawerLayout.openDrawer(Gravity.RIGHT);
        } else if (type == FILTERTYPE) {
            if (areaList.size() == 0 && typeList.size() == 0 && brandList.size() == 0) {
                return;
            }
            areaBrandCatLayout.setVisibility(View.GONE);
            categeryLayout.setVisibility(View.VISIBLE);

            drawerLayout.openDrawer(Gravity.RIGHT);
            categeryLayout.setAreaData(areaList, areaSelectList);
            categeryLayout.setTypeData(typeList, typeSelectList);
            categeryLayout.setBrandData(brandList, brandSelectList);
        }
    }

    /**
     * 初始化热门地区 或者 品牌界面
     */
    private void initScreen1() {
        areaBrandCatLayout.setSlideTitle("热门选择");
        areaBrandCatLayout.setTabs("热门选择", "字母排序");
        areaBrandCatLayout.setOnSelectListener(new GlobalTabCatLayout.OnSelectListener() {

            @Override
            public void onEnterClick(String condition, String code, int show_type, AppCompatButton tagButton) {
                filterLayout.setAllStatus(false);
                updateOptionStatus();
                clearOption();
                if (show_type == SHOW_TYPE_BRAND) {
                    brandCondition = code;
                    filterLayout2.setBrandBtnText(condition);
                } else {
                    areaCondition = code;
                    filterLayout2.setAreBtnText(condition);
                }
                getSearchData();
                drawerLayout.closeDrawer(Gravity.RIGHT);
            }

            @Override
            public void onBackSelectList(List<Contact> conditionList, int show_type, AppCompatButton tagButton) {
                if (show_type == SHOW_TYPE_BRAND) {
                    brandSelectList.clear();
                    brandSelectList.addAll(conditionList);
                } else {
                    areaSelectList.clear();
                    areaSelectList.addAll(conditionList);
                }
            }

            @Override
            public void onClose() {
                drawerLayout.closeDrawer(Gravity.RIGHT);
            }
        });
    }


    /**
     * 更新筛选按钮颜色
     */
    private void updateOptionStatus() {
        if (areaSelectList.size() > 0 || brandSelectList.size() > 0 || typeSelectList.size() > 0) {
            filterLayout.setOptionStatus(true);
        } else {
            filterLayout.setOptionStatus(false);
        }
    }

    /**
     * 初始化筛选界面
     */
    private void initScreen2() {
        categeryLayout.setOnSelectListener(new GlobalCategeryLayout.OnSelectListener() {
            @Override
            public void moreClick(short type) {
                if (drawerLayout.isDrawerOpen(Gravity.RIGHT)) {
                    drawerLayout.closeDrawer(Gravity.RIGHT);
                }
                switch (type) {
                    case GlobalCategeryLayout.GLOBAL_BRAND:
                        showDrawLayout(BRANDTYPE);
                        break;
                    case GlobalCategeryLayout.GLOBAL_AREA:
                        showDrawLayout(AREATYPE);
                        break;
                }
            }

            @Override
            public void onEnterClick(Contact brand, Contact area, Contact type) {
                brandCondition = brand.getCode();
                areaCondition = area.getCode();
                cateCondition = type.getCode();

                getSearchData();
                drawerLayout.closeDrawer(Gravity.RIGHT);
                filterLayout2.setAreBtnText(area.getName());
                filterLayout2.setBrandBtnText(brand.getName());
                updateOptionStatus();
            }

            @Override
            public void onResetClick() {

            }

            @Override
            public void onBackSelectList(List<Contact> brandList, List<Contact> areaList, List<Contact> typeList) {
                brandSelectList.clear();
                brandSelectList.addAll(brandList);

                areaSelectList.clear();
                areaSelectList.addAll(areaList);

                typeSelectList.clear();
                typeSelectList.addAll(typeList);
            }
        });

    }

    @Override
    public void onRefresh() {
        linearAdapter.setEnableLoadMore(false);
        gridAdapter.setEnableLoadMore(false);
        //如果没有选择筛选项，
        if (TextUtils.isEmpty(areaCondition) && TextUtils.isEmpty(brandCondition) && TextUtils.isEmpty(cateCondition)
                && salesSort.equals("") && priceSort.equals("") && singleProduct.equals("0")) {
            getFirstPageData();
        } else {
            getSearchData();
        }

    }

    @Override
    public void onLoadMoreRequested() {
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        params.put("pageNum", current_page);//查询的页数
        params.put("pageSize", PAGE_SIZE);//分页显示数量
        params.put("brandConditions", getCondition(brandCondition, defBrandCondition));//品牌条件
        params.put("areaConditions", getCondition(areaCondition, defAreaCondition));//地区条件
        params.put("cateConditions", getCondition(cateCondition, defCateCondition));//分类条件
        params.put("singleProductions", singleProduct);//超值单品 1是 0否
        params.put("salesSort", salesSort);//销量排序0无排序 1升序 2降序
        params.put("priceSort", priceSort);//价格排序0无排序 1升序 2降序
        getMore(params);
    }


    public String getCondition(String condition, String def) {
        return TextUtils.isEmpty(condition) ? def : condition;
    }

    /**
     * 获取更多数据
     */
    private void getMore(Map<String, Object> params) {
        new ItemsMode(mContext).getRelationList(params, new ApiResultObserver<RelationBean>(mContext) {

            @Override
            public void onError(ApiException e) {
                if (isLinear) {
                    linearAdapter.loadMoreFail();
                } else {
                    gridAdapter.loadMoreFail();
                }
            }

            @Override
            public void onSuccess(RelationBean apiResult) {
                List<CmsItemsBean> list = apiResult.getList();
                if (list != null) {
                    gridList.addAll(list);
                }
                if (isLinear) {
                    linearAdapter.notifyDataSetChanged();
                    if (list == null || list.size() < PAGE_SIZE) {
                        linearAdapter.loadMoreEnd(false);
                    } else {
                        current_page++;
                        linearAdapter.loadMoreComplete();
                    }
                } else {
                    gridAdapter.notifyDataSetChanged();
                    if (list == null || list.size() < PAGE_SIZE) {
                        gridAdapter.loadMoreEnd(false);
                    } else {
                        current_page++;
                        gridAdapter.loadMoreComplete();
                    }
                }
            }
        });
    }


    private BaseQuickAdapter getAdapter() {
        return (BaseQuickAdapter) (recyclerview.getAdapter());
    }

    /**
     * 获取查询数据
     */
    private void getSearchData(String id, String pageNum, String pageSize, String brandConditions, String areaConditions, String cateConditions, String singleProductions, String salesSort, String priceSort) {
        gridList.clear();
        getAdapter().notifyDataSetChanged();
        getAdapter().setEmptyView(R.layout.global_list_loading_view, (ViewGroup) recyclerview.getParent());
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        params.put("pageNum", pageNum);//查询的页数
        params.put("pageSize", pageSize);//分页显示数量
        params.put("brandConditions", getCondition(brandConditions, defBrandCondition));//品牌条件
        params.put("areaConditions", getCondition(areaConditions, defAreaCondition));//地区条件
        params.put("cateConditions", getCondition(cateConditions, defCateCondition));//分类条件
        params.put("singleProductions", singleProductions);//超值单品 1是 0否
        params.put("salesSort", salesSort);//销量排序0无排序 1升序 2降序
        params.put("priceSort", priceSort);//价格排序0无排序 1升序 2降序
        if (lgroup.equals(TWO_YUAN_KEY)) {
            params.put("sale_price_end", "200");//价格排序0无排序 1升序 2降序
        }
        showLoading();
        new ItemsMode(mContext).getRelationList(params, new ApiResultObserver<RelationBean>(mContext) {

            @Override
            public void onError(ApiException e) {
                hideLoading();
                swipeRefresh.setRefreshing(false);
                getAdapter().setEmptyView(errorView);
            }

            @Override
            public void onSuccess(RelationBean apiResult) {
                hideLoading();
                if (apiResult != null && apiResult.getList() != null) {
                    List<CmsItemsBean> list = apiResult.getList();
                    gridList.clear();
                    gridList.addAll(list);
                }

                if (gridList.size() == 0) {
                    getAdapter().setEmptyView(notDataView);
                }
                swipeRefresh.setRefreshing(false);
                if (isLinear) {
                    linearAdapter.notifyDataSetChanged();
                    if (gridList == null || gridList.size() < PAGE_SIZE) {
                        linearAdapter.loadMoreEnd(false);
                    } else {
                        linearAdapter.loadMoreComplete();
                    }
                } else {
                    gridAdapter.notifyDataSetChanged();
                    if (gridList == null || gridList.size() < PAGE_SIZE) {
                        gridAdapter.loadMoreEnd(false);
                    } else {
                        gridAdapter.loadMoreComplete();
                    }
                }
            }
        });
    }

    /**
     * 获取筛选项数据
     */
    private void getOptionData() {
        new ItemsMode(mContext).getGlobalDistrictBrand(new ApiResultObserver<DistrictBrandBean>(mContext) {
            @Override
            public void onSuccess(DistrictBrandBean apiResult) {
                List<DistrictBrandBean.PropertyBean> brandinfoList = apiResult.getGlobalbrandinfo();
                if (null != brandinfoList) {
                    Map<String, List<Contact>> brandMap = new HashMap<String, List<Contact>>();
                    Log.i(TAG, brandinfoList.size() + "");
                    for (int i = 0; i < brandinfoList.size(); i++) {
                        String value = brandinfoList.get(i).getPropertyValue().get(0);
                        String index = PinyinUtils.getPinyinFirstLetter(value).toUpperCase();
                        String code = brandinfoList.get(i).getPropertyName();
                        if (brandMap.get(index) == null) {
                            List<Contact> list = new ArrayList<Contact>();
                            list.add(new Contact(index, value, code));
                            brandMap.put(index, list);
                        } else {
                            brandMap.get(index).add(new Contact(index, value, code));
                        }
                    }
                    brandList.clear();
                    for (int i = 0; i < indexStr.length; i++) {
                        List<Contact> list = brandMap.get(indexStr[i]);
                        if (list != null) {
                            brandList.addAll(list);
                        }
                    }
                }

                List<DistrictBrandBean.RegionBean> regionList = apiResult.getRegionlist();
                if (null != regionList) {
                    Log.i(TAG, regionList.size() + "");
                    Map<String, List<Contact>> areaMap = new HashMap<String, List<Contact>>();
                    for (int i = 0; i < regionList.size(); i++) {
                        String value = regionList.get(i).getRegion_name();
                        String index = PinyinUtils.getPinyinFirstLetter(value).toUpperCase();
                        String code = regionList.get(i).getRegion_code();
                        if (areaMap.get(index) == null) {
                            List<Contact> list = new ArrayList<Contact>();
                            list.add(new Contact(index, value, code));
                            areaMap.put(index, list);
                        } else {
                            areaMap.get(index).add(new Contact(index, value, code));
                        }
                    }
                    areaList.clear();
                    for (int i = 0; i < indexStr.length; i++) {
                        List<Contact> list = areaMap.get(indexStr[i]);
                        if (list != null) {
                            areaList.addAll(list);
                        }
                    }
                }
            }

            @Override
            public void onError(ApiException e) {
                Log.e(TAG, e.getMessage());
            }
        });
    }

    @Override
    public void onBackPressed() {
        if (drawerLayout.isDrawerOpen(Gravity.RIGHT)) {
            drawerLayout.closeDrawer(Gravity.RIGHT);
            return;
        }
        RouterModule.onRouteBack();
        super.onBackPressed();
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706A007);
    }
}
