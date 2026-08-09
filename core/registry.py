"""因子定义注册表：加载和管理 factors/ 目录下的 YAML 文件。"""
import os
from typing import Dict, List, Optional

import yaml

from .factor_model import FactorDef


class FactorRegistry:
    """扫描 factors/ 目录，加载所有 .yaml 因子定义文件。"""

    def __init__(self, factors_dir: str):
        self.factors_dir = factors_dir
        self._factors: Dict[str, FactorDef] = {}

    def load(self) -> Dict[str, FactorDef]:
        """扫描目录并加载所有因子定义。"""
        self._factors.clear()
        if not os.path.isdir(self.factors_dir):
            return self._factors
        for root, dirs, files in os.walk(self.factors_dir):
            for fname in sorted(files):
                if not fname.endswith((".yaml", ".yml")):
                    continue
                path = os.path.join(root, fname)
                with open(path, "r", encoding="utf-8") as f:
                    raw = yaml.safe_load(f)
                if not raw or "id" not in raw:
                    continue
                factor = FactorDef(**raw)
                self._factors[factor.id] = factor
        return self._factors

    def get(self, factor_id: str) -> Optional[FactorDef]:
        return self._factors.get(factor_id)

    def all(self) -> Dict[str, FactorDef]:
        return self._factors

    def by_category(self) -> Dict[str, List[FactorDef]]:
        """按 category 分组返回因子列表。"""
        groups: Dict[str, List[FactorDef]] = {}
        for f in self._factors.values():
            groups.setdefault(f.category, []).append(f)
        return groups

    def categories(self) -> List[str]:
        return sorted(self.by_category().keys())
